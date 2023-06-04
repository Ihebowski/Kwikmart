import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/constants.dart';
import 'package:grocery_app/screens/wishlist/widgets/wishlist_delete_modal.dart';
import 'package:grocery_app/services/firestore_database.dart';

class WishlistItem extends StatefulWidget {
  final String wishId;
  final String productId;
  final String productQuantity;

  const WishlistItem({
    Key? key,
    required this.wishId,
    required this.productId,
    required this.productQuantity,
  }) : super(key: key);

  @override
  State<WishlistItem> createState() => _WishlistItemState();
}

class _WishlistItemState extends State<WishlistItem> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection("Products")
          .doc(widget.productId.trim())
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              color: bgMainColor,
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Error"),
          );
        } else {
          return Container(
            padding: const EdgeInsets.all(15),
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: bgSecondColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    FutureBuilder(
                      future: FirestoreDatabase().getImage(
                        snapshot.data!["product_image"].toString(),
                      ),
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
                          return Image.network(
                            snapshot.data.toString(),
                            height: 90,
                            width: 90,
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!["product_name"].toString(),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${widget.productQuantity} kg",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    size: 30,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return WishlistDeleteModal(
                            itemId: widget.wishId.trim(),
                            itemName: snapshot.data!["product_name"].toString(),
                          );
                        });
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
