import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreDatabase {
  static Future<void> deleteItem({required String docId}) async {
    // ignore: avoid_print
    print(docId);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Wishlist").doc(docId.trim());
    await documentReference
        .delete()
        // ignore: avoid_print
        .whenComplete(() => print("Deleted"))
        // ignore: avoid_print
        .catchError((e) => print(e));
  }
}
