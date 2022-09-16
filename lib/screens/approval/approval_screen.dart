import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/providers/user_provider.dart';
import 'package:cook_kuy/screens/router.dart';
import 'package:cook_kuy/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({Key? key}) : super(key: key);

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Approval",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        body: SafeArea(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('approval')
                .where('uid', isEqualTo: userProvider.getUser.uid)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  padding: EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    Timestamp date =
                        snapshot.data!.docs[index]['date_published'];
                    DateTime dateTime = date.toDate();
                    final approval =
                        snapshot.data!.docs[index]['approval_status'];
                    return InkWell(
                      onTap: (){
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed(AppRouter.approvalDetail, arguments: snapshot.data!.docs[index]['recipe_id']);
                      },
                      child: Card(
                        child: ListTile(
                          leading: SizedBox(
                              width: 60, child: Image.network(snapshot.data!.docs[index]['image_url'])),
                          title: Text(snapshot.data!.docs[index]['name']),
                          subtitle:
                              Text(DateFormat('dd MMMM yyyy').format(dateTime)),
                          trailing: Text(
                            approval,
                            style: TextStyle(
                                color: approval == "Pending"
                                    ? kuningSkripsi
                                    : approval == "Accepted"
                                        ? ijoSkripsi
                                        : Colors.redAccent),
                          ),
                        ),
                      ),
                    );
                  });
            },
          ),
        ));
  }
}
