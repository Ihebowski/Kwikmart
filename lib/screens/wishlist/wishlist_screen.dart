import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/constants.dart';
import 'package:grocery_app/screens/categories/categories_screen.dart';
import 'package:grocery_app/screens/landing/landing_screen.dart';
import 'package:grocery_app/screens/wishlist/widgets/wishlist_item.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgMainColor,
      appBar: AppBar(
        backgroundColor: bgMainColor,
        title: const Text("Wishlist"),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LandingScreen(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          color: bgForthColor,
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Wishlist")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
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
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CategoriesScreen())),
                        child: Image.asset(
                          "assets/images/empty-wishlist.png",
                          height: 150,
                          width: 150,
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView.separated(
                        itemCount: snapshot.data!.docs.length,
                        separatorBuilder: (context, index) {
                          return const Divider(
                            height: 8,
                            color: Colors.transparent,
                          );
                        },
                        itemBuilder: (context, index) {
                          return WishlistItem(
                            wishId: snapshot.data!.docs[index].reference.id,
                            productId: snapshot.data!.docs[index]['product_id'],
                            productQuantity: snapshot.data!.docs[index]
                                ['product_quantity'],
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
