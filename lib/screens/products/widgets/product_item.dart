import 'package:flutter/material.dart';
import 'package:grocery_app/constants.dart';
import 'package:grocery_app/screens/products/widgets/add_product_modal.dart';
import 'package:grocery_app/services/firestore_database.dart';

class ProductItem extends StatefulWidget {
  final String productId;
  final String productName;
  final String productImage;
  final String productUnit;

  const ProductItem({
    Key? key,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productUnit,
  }) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FutureBuilder(
          future: FirestoreDatabase().getImage(widget.productImage),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error"),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: bgMainColor,
                ),
              );
            } else {
              return Image.network(
                snapshot.data.toString(),
                height: 90,
                width: 90,
              );
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 10.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.productName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: bgThirdColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.add),
                  ),
                ),
                onTap: () {
                  showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    context: context,
                    builder: (context) => SheetContainer(
                      productId: widget.productId,
                      productName: widget.productName,
                      productImage: widget.productImage,
                      productUnit: widget.productUnit,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
