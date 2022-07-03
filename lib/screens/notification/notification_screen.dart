import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/screens/router.dart';
import 'package:cook_kuy/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Notification",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('notification')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
                separatorBuilder: (context, index) =>
                    Divider(height: 1, color: Colors.grey),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final notifData = snapshot.data!.docs[index];
                  return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(notifData['uid'])
                          .snapshots(),
                      builder: (context, snapshot2) {
                        final userData = snapshot2.data;
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRouter.anotherAccount,
                                arguments: notifData['uid']);
                          },
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                              backgroundColor: ijoSkripsi,
                            ),
                            title: Text(
                                '${userData!['username']} is following you'),
                            subtitle: const Text('click for see the profile'),
                          ),
                        );
                      });
                }),
          );
        },
      ),
    ));
  }
}
