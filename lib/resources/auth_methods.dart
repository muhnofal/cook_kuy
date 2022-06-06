import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/model/user.dart' as model;
import 'package:cook_kuy/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetail() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  Future<String> registerUser(
      {required String email,
      required String password,
      required String username,
      required String imageFile}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        //register user
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print('ini creadential ${credential.user!.uid}');

        // String photoUrl = await StorageMethods()
        //     .uploadImageToStorage('profilePics', file, false);
        //add user to our database

        model.User user = model.User(
          username: username,
          uid: credential.user!.uid,
          email: email,
          followers: [],
          following: [],
          photoUrl: imageFile,
          bio: "My favorite ingredients is egg :)"
        );

        await _firestore.collection('users').doc(credential.user!.uid).set(
              user.toJson(),
            );

        //

        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error accurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
