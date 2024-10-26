import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/constants.dart';
import 'package:grocery_app/screens/products/widgets/product_item.dart';

class ProductContainer extends StatefulWidget {
  final String seachText;
  const ProductContainer({
    Key? key,
    required this.seachText,
  }) : super(key: key);

  @override
  _ProductContainerState createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {
  @override
  Widget build(BuildContext context) {
    String toCapitalize(String s) => s[0].toUpperCase() + s.substring(1);
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Products")
            .where("product_name",
                isGreaterThanOrEqualTo: toCapitalize(widget.seachText))
            .where("product_name",
                isLessThan: toCapitalize(widget.seachText) + 'z')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          } else {
            // ignore: avoid_print
            print(snapshot.data!.docs.length);

            return Container(
              padding: const EdgeInsets.only(top: 15),
              height: 430,
              decoration: BoxDecoration(
                color: bgSecondColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Products",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: textSecond,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Divider(),
                  ),
                  Expanded(
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 0,
                        ),
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return ProductItem(
                              productId: snapshot.data!.docs[index].id,
                              productName: snapshot.data!.docs[index]
                                  ["product_name"],
                              productImage: snapshot.data!.docs[index]
                                  ["product_image"],
                              productUnit: snapshot.data!.docs[index]
                                  ["product_unit"]);
                        }),
                  ),
                ],
              ),
            );
          }
        });
  }
}
