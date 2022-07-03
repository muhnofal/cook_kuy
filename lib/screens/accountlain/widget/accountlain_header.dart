import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/resources/firestore_methods.dart';
import 'package:cook_kuy/screens/account/widget/follow_following_widget.dart';
import 'package:cook_kuy/utils/colors.dart';
import 'package:cook_kuy/utils/utils.dart';
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
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  List userToken = [];
  String username = "";

  @override
  void initState() {
    super.initState();
    getanotherUserData();
  }

  getanotherUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.anotherUserId)
          .get();

      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      userToken = userSnap.data()!['tokens'];
      username = userSnap.data()!['username'];
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        e.toString(),
        context,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container()
        : Material(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(userData['photoUrl']),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              userData['username'],
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              userData['bio'],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 45.0),
                          child: FollowAndFollowingWidget(
                            count: followers.toString(),
                            labeltext: "Followers",
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        const SizedBox(
                          height: 40,
                          child: VerticalDivider(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 45.0),
                          child: FollowAndFollowingWidget(
                            count: following.toString(),
                            labeltext: "Following",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: FirebaseAuth.instance.currentUser!.uid ==
                                    widget.anotherUserId
                                ? Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border:
                                          Border.all(color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Text(
                                      "This is your profile",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: ijoSkripsi,
                                      ),
                                    ),
                                  )
                                : isFollowing
                                    ? InkWell(
                                        onTap: () {
                                          FirestoreMethods().followUser(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              widget.anotherUserId,
                                              userToken.last);
                                          setState(() {
                                            isFollowing = false;
                                            followers--;
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.grey.shade400),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: const Text(
                                            "Unfollow",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: ijoSkripsi,
                                            ),
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          FirestoreMethods().followUser(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              widget.anotherUserId,
                                              userToken.last);
                                          setState(() {
                                            isFollowing = true;
                                            followers++;
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            color: ijoSkripsi,
                                            border: Border.all(
                                                color: Colors.grey.shade400),
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
              ),
            ),
          );
  }
}
