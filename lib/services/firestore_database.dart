import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FirestoreDatabase {
  String? downloadUrl;

  Future getImage(String path) async {
    try {
      await downloadImageUrl(path);
      return downloadUrl;
    } catch (e) {
      debugPrint("error - $e");
      return null;
    }
  }

  Future<void> downloadImageUrl(String path) async {
    downloadUrl = await FirebaseStorage.instance
        .ref()
        .child(path.toLowerCase())
        .getDownloadURL();
    debugPrint(downloadUrl.toString());
  }
}
