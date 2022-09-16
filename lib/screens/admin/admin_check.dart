import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/screens/admin/approval_admin.dart';
import 'package:cook_kuy/screens/admin/navigation_bar_admin.dart';
import 'package:cook_kuy/screens/navigationBar/navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminCheck extends StatefulWidget {
  const AdminCheck({Key? key}) : super(key: key);

  @override
  State<AdminCheck> createState() => _AdminCheckState();
}

class _AdminCheckState extends State<AdminCheck> {
  String role = "user";

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  void _checkRole() async {
    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection(
        'users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    setState(() {
      role = snap['role'];
    });
    if (role == 'user') {
      navigateNext(const NewNavigationScreen());
    } else if (role == 'admin') {
      navigateNext(const AdminNavigationScreen());
    }
  }

  void navigateNext(Widget route) {
    Timer(Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => route));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/cook_kuy_logo.png', width: 200, height: 200,)
          ],
        ),
      ),
    );
  }
}
