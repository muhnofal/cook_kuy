import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/resources/firestore_methods.dart';
import 'package:cook_kuy/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminCommentReport extends StatefulWidget {
  const AdminCommentReport({Key? key}) : super(key: key);

  @override
  State<AdminCommentReport> createState() => _AdminCommentReportState();
}

class _AdminCommentReportState extends State<AdminCommentReport> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Recipe Approval"),
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  child: Text("Logout"),
                  value: "Logout",
                ),
              ],
              onSelected: (item) {
                setState(
                  () {
                    setState(() {
                      FirebaseAuth.instance.signOut();
                    });
                  },
                );
              },
            ),
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('commentReport')
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final data = snapshot.data!.docs;
              return snapshot.data!.docs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.comment,
                            size: 80,
                            color: Colors.black12,
                          ),
                          Text(
                            "There's no reported comment",
                            style: TextStyle(color: Colors.black12),
                          )
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Timestamp date = data[index]['date_published'];
                        DateTime dateTime = date.toDate();
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[300]!,
                                offset: const Offset(
                                  3.0,
                                  6.0,
                                ), //Offset
                                blurRadius: 8.0,
                                // spreadRadius: 1.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage: NetworkImage(
                                        data[index]['profile_pic'],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(data[index]['name']),
                                          Text(
                                            DateFormat('dd MMMM yyyy')
                                                .format(dateTime),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(data[index]['text']),
                                const SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            FirestoreMethods().deleteComment(
                                                data[index]['recipe_id'],
                                                data[index]['comment_id']);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "You delete the comment"),
                                            ));
                                          });
                                        },
                                        child: const Text("Delete"),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          primary: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          FirestoreMethods().safeComment(
                                              data[index]['comment_id']);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content:
                                                Text("The comment is safe"),
                                          ));
                                        },
                                        child: const Text("Safe"),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          primary: ijoSkripsi,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
            }),
      ),
    );
  }
}
