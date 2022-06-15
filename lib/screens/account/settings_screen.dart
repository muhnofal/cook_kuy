import 'package:cook_kuy/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Row(
              children: const [
                Icon(
                  Icons.language_rounded,
                  color: ijoSkripsi,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Change Language")
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  FirebaseAuth.instance.signOut();
                });
              },
              child: Row(
                children: const [
                  Icon(
                    Icons.logout,
                    color: ijoSkripsi,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Log out")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
