import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/constants.dart';
import 'package:grocery_app/screens/categories/widgets/category_item.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgMainColor,
      appBar: AppBar(
        backgroundColor: bgMainColor,
        elevation: 0,
        title: const Text("Categories"),
        centerTitle: true,
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
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, left: 10.0, right: 10.0), //White bg padding
                child: Container(
                  padding: const EdgeInsets.all(5.0), //Padding inside white
                  decoration: BoxDecoration(
                    color: bgSecondColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0), //Padding top botton item
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Categories")
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
                            child: Image.asset(
                              "assets/images/widget-warning.png",
                              height: 150,
                              width: 150,
                            ),
                          );
                        } else {
                          return GridView.builder(
                            itemCount: snapshot.data!.docs.length,
                            // shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 5,
                              childAspectRatio: MediaQuery.of(context)
                                      .size
                                      .width /
                                  (MediaQuery.of(context).size.height / 1.7),
                            ),
                            itemBuilder: (context, index) {
                              return GridTile(
                                child: CategoryItem(
                                  categoryName: snapshot.data!.docs[index]
                                      ['category_name'],
                                  categoryImage: snapshot.data!.docs[index]
                                      ['category_image'],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
