import 'package:flutter/material.dart';
import 'package:grocery_app/constants.dart';
import 'package:grocery_app/screens/products/products_screen.dart';
import 'package:grocery_app/services/firestore_database.dart';

class CategoryItem extends StatefulWidget {
  final String categoryName;
  final String categoryImage;

  const CategoryItem({
    Key? key,
    required this.categoryName,
    required this.categoryImage,
  }) : super(key: key);

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  late Future _loadImageUrl;

  @override
  void initState() {
    _loadImageUrl = FirestoreDatabase().getImage(widget.categoryImage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductsScreen(
              name: widget.categoryName,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: bgThirdColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: FutureBuilder(
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
                    return Image.network(
                      snapshot.data.toString(),
                      height: 60,
                      width: 60,
                    );
                  }
                },
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.categoryName,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
