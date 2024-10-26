import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/constants.dart';
import 'package:grocery_app/screens/wishlist/wishlist_screen.dart';
import 'package:grocery_app/services/firestore_database.dart';

// ignore: must_be_immutable
class SheetContainer extends StatefulWidget {
  final String productId;
  final String productName;
  final String productImage;
  final String productUnit;

  bool shouldEnable = false;
  int quantity = 0;

  SheetContainer({
    Key? key,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productUnit,
  }) : super(key: key);

  @override
  _SheetContainerState createState() => _SheetContainerState();
}

class _SheetContainerState extends State<SheetContainer> {
  late Future _loadImageUrl;

  @override
  void initState() {
    _loadImageUrl = FirestoreDatabase().getImage(widget.productImage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                future: _loadImageUrl,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error"),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: bgMainColor,
                      ),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: bgForthColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image.network(
                        snapshot.data.toString(),
                        height: 120,
                        width: 120,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(
                width: 25,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.productName,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: bgThirdColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          color: iconSecond,
                          icon: const Icon(
                            Icons.remove,
                            size: 20,
                          ),
                          onPressed: widget.shouldEnable
                              ? () {
                                  setState(() {
                                    widget.quantity = widget.quantity - 1;
                                    (widget.quantity > 0)
                                        ? widget.shouldEnable = true
                                        : widget.shouldEnable = false;
                                  });
                                }
                              : null,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        widget.quantity.toString(),
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: textSecond,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.productUnit,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: textSecond,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: bgThirdColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          color: iconSecond,
                          icon: const Icon(
                            Icons.add,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              widget.quantity = widget.quantity + 1;
                              widget.quantity > 0
                                  ? widget.shouldEnable = true
                                  : widget.shouldEnable = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    height: 40,
                    minWidth: 160,
                    color: bgThirdColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    disabledColor: bgForthColor,
                    child: const Text(
                      "Add To Wishlist",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    onPressed: widget.quantity > 0
                        ? () {
                            FirebaseFirestore.instance
                                .collection("Wishlist")
                                .doc()
                                .set({
                              "product_id": widget.productId.trim(),
                              "product_quantity": widget.quantity.toString(),
                            }).then((_) {
                              // ignore: avoid_print
                              print("Added");
                              // ignore: avoid_print, invalid_return_type_for_catch_error
                            }).catchError((error) => print("error : $error"));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WishlistScreen(),
                              ),
                            );
                          }
                        : null,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
