import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/resources/firestore_methods.dart';
import 'package:cook_kuy/screens/account/widget/follow_following_widget.dart';
import 'package:cook_kuy/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AccountHeaderLain extends StatefulWidget {
  final anotherUserId;
  const AccountHeaderLain({Key? key, required this.anotherUserId})
      : super(key: key);

  @override
  State<AccountHeaderLain> createState() => _AccountHeaderLainState();
}

class _AccountHeaderLainState extends State<AccountHeaderLain> {
  var userData = {};

  getanotherUserData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.anotherUserId)
          .get();

      userData = userSnap.data()!;
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    getanotherUserData;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 14.0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/images/person.png"),
                ),
              ),
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 45.0),
                    child: FollowAndFollowingWidget(
                      count: "360",
                      labeltext: "Followers",
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 45.0),
                    child: FollowAndFollowingWidget(
                      count: "240",
                      labeltext: "Following",
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "RavyAryo",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  "My favorite ingredients is egg",
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      FirestoreMethods().followUser(
                          FirebaseAuth.instance.currentUser!.uid,
                          userData['uid']);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: ijoSkripsi,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        "Follow",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
