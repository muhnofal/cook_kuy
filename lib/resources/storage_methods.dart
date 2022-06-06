import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    Reference reference =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if(isPost){
      String id = const Uuid().v1();
      reference = reference.child(id);
    }

    UploadTask uploadTask = reference.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<List<String>> uploadMultiImageToStorage(
      String childName, List<Uint8List> files, bool isPost) async {
    // Reference reference =
    //     _storage.ref().child(childName).child(_auth.currentUser!.uid);

    // UploadTask uploadTask;
    // for (var file in files) {
    //   uploadTask = reference.putData(file);
    // }
    List<String> imagesUrl = await Future.wait(files.map((file) => uploadImageToStorage(childName, file, isPost)));
    print(imagesUrl);
    return imagesUrl;
  }
}
