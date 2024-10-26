import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/constants.dart';
import 'package:grocery_app/screens/products/widgets/product_item.dart';

class ProductsScreen extends StatefulWidget {
  final String name;
  const ProductsScreen({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgMainColor,
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
        elevation: 0,
        backgroundColor: bgMainColor,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          color: bgForthColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: bgSecondColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Products")
                        .where("product_type",
                            isEqualTo: widget.name.toLowerCase())
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: bgMainColor,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Image.asset(
                            "assets/images/widget-error.png",
                            height: 150,
                            width: 150,
                          ),
                        );
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Image.asset(
                            "assets/images/widget-warning.png",
                            height: 150,
                            width: 150,
                          ),
                        );
                      } else {
                        return GridView.builder(
                          itemCount: snapshot.data!.docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 0,
                          ),
                          itemBuilder: (context, index) {
                            return GridTile(
                                child: ProductItem(
                              productId: snapshot.data!.docs[index].id,
                              productName: snapshot.data!.docs[index]
                                  ['product_name'],
                              productImage: snapshot.data!.docs[index]
                                  ['product_image'],
                              productUnit: snapshot.data!.docs[index]
                                  ['product_unit'],
                            ));
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     // Navigator.push(
      //     //   context,
      //     //   MaterialPageRoute(
      //     //     builder: (context) => const WishlistScreen(),
      //     //   ),
      //     // );
      //   },
      //   icon: const Icon(Icons.favorite),
      //   label: const Text("Wishlist"),
      // ),
    );
  }
}
