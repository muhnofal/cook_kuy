import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/screens/router.dart';
import 'package:cook_kuy/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ApprovalAdmin extends StatefulWidget {
  const ApprovalAdmin({Key? key}) : super(key: key);

  @override
  State<ApprovalAdmin> createState() => _ApprovalAdminState();
}

class _ApprovalAdminState extends State<ApprovalAdmin> {
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
              .collection('approval')
              .where('approval_status', isEqualTo: "Pending")
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return snapshot.data!.docs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.approval,
                          size: 80,
                          color: Colors.black12,
                        ),
                        Text(
                          "There's no Approval",
                          style: TextStyle(color: Colors.black12),
                        )
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Timestamp date =
                          snapshot.data!.docs[index]['date_published'];
                      DateTime dateTime = date.toDate();
                      final approval =
                          snapshot.data!.docs[index]['approval_status'];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pushNamed(
                              AppRouter.approvalDetailAdmin,
                              arguments: snapshot.data!.docs[index]
                                  ['recipe_id']);
                        },
                        child: Card(
                          child: ListTile(
                            leading: SizedBox(
                                width: 60,
                                child: Image.network(
                                    snapshot.data!.docs[index]['image_url'])),
                            title: Text(snapshot.data!.docs[index]['name']),
                            subtitle: Text(
                                DateFormat('dd MMMM yyyy').format(dateTime)),
                            trailing: Text(
                              approval,
                              style: TextStyle(
                                  color: approval == "Pending"
                                      ? kuningSkripsi
                                      : approval == "Approved"
                                          ? ijoSkripsi
                                          : Colors.redAccent),
                            ),
                          ),
                        ),
                      );
                    });
          },
        ),
      ),
    );
  }
}
