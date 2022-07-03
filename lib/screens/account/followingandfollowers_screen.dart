import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/screens/account/widget/persistent_header.dart';
import 'package:cook_kuy/screens/router.dart';
import 'package:cook_kuy/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../resources/firestore_methods.dart';

class FollowingAndFollowersScreen extends StatefulWidget {
  const FollowingAndFollowersScreen({Key? key}) : super(key: key);

  @override
  State<FollowingAndFollowersScreen> createState() =>
      _FollowingAndFollowersScreenState();
}

class _FollowingAndFollowersScreenState
    extends State<FollowingAndFollowersScreen> {

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            labelColor: Colors.black,
            indicatorColor: ijoSkripsi,
            tabs: [
              Tab(
                text: "Followers",
              ),
              Tab(
                text: "Following",
              )
            ],
          ),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            userProvider.getUser.username.toString(),
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
        body: TabBarView(children: [
          //ini tab following
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot1) {
                if (!snapshot1.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: ijoSkripsi),
                  );
                }
                final userDoc = snapshot1.data;
                List followingList = userDoc!.get('following');
                return followingList.length == 0
                    ? Center(
                        child: Text(
                          "you haven't followed anyone",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      )
                    : SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: ListView.builder(
                          itemCount: followingList.length,
                          itemBuilder: (context, index) {
                            return StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(followingList[index])
                                    .snapshots(),
                                builder: (context, snapshot2) {
                                  if (!snapshot2.hasData) {
                                    return Container();
                                  }
                                  final userData = snapshot2.data;
                                  final List ownerFollower =
                                      userData!['followers'];
                                  final List userToken = userData['tokens'];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          AppRouter.anotherAccount,
                                          arguments: userData['uid']);
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 60,
                                                  height: 60,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: Image.network(
                                                        userData['photoUrl']),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                //ini pal
                                                Text(
                                                  userData['username'],
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            //ini pal
                                            ownerFollower.contains(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                ? InkWell(
                                                    onTap: () {
                                                      FirestoreMethods()
                                                          .followUser(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        userData['uid'],
                                                        userToken.last,
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: const Color(
                                                                0xFFeeeeee)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                      child: const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 8,
                                                                horizontal: 20),
                                                        child: Text(
                                                          "Unfollow",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                                : InkWell(
                                                    onTap: () {
                                                      FirestoreMethods()
                                                          .followUser(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        userData['uid'],
                                                        userToken.last,
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: const Color(
                                                                0xFFeeeeee)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                      child: const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 8,
                                                                horizontal: 20),
                                                        child: Text(
                                                          "Follow",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                          ],
                                        )),
                                  );
                                });
                          },
                        ),
                      );
              }),
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot1) {
                if (!snapshot1.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: ijoSkripsi),
                  );
                }
                final userDoc = snapshot1.data;
                List followersList = userDoc!.get('followers');
                return followersList.length == 0
                    ? Center(
                        child: Text(
                          "you don't have followers",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      )
                    : SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: ListView.builder(
                          itemCount: followersList.length,
                          itemBuilder: (context, index) {
                            return StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(followersList[index])
                                    .snapshots(),
                                builder: (context, snapshot2) {
                                  if (!snapshot2.hasData) {
                                    return Container();
                                  }
                                  final userData = snapshot2.data;
                                  final List ownerFollower =
                                      userData!['followers'];
                                  final List userToken = userData['tokens'];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          AppRouter.anotherAccount,
                                          arguments: userData['uid']);
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 60,
                                                  height: 60,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: Image.network(
                                                        userData['photoUrl']),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                //ini pal
                                                Text(
                                                  userData['username'],
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            //ini pal
                                            ownerFollower.contains(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                ? InkWell(
                                                    onTap: () {
                                                      FirestoreMethods()
                                                          .followUser(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        userData['uid'],
                                                        userToken.last,
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: const Color(
                                                                0xFFeeeeee)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                      child: const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 8,
                                                                horizontal: 20),
                                                        child: Text(
                                                          "Unfollow",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                                : InkWell(
                                                    onTap: () {
                                                      FirestoreMethods()
                                                          .followUser(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        userData['uid'],
                                                        userToken.last,
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: const Color(
                                                                0xFFeeeeee)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                      child: const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 8,
                                                                horizontal: 20),
                                                        child: Text(
                                                          "Follow",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                          ],
                                        )),
                                  );
                                });
                          },
                        ),
                      );
              }),
        ]),
      ),
    );
  }
}
