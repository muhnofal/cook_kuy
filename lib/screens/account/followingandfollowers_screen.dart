import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/screens/account/widget/persistent_header.dart';
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
  final List<User> _users = [
    User(
        'Ravy Aryo',
        '@ravyaryo',
        "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        true),
    User(
        'Irsal Diki',
        '@irsaldiki',
        "https://www.mnp.ca/-/media/foundation/integrations/personnel/2020/12/16/13/57/personnel-image-4483.jpg?h=800&w=600&hash=9D5E5FCBEE00EB562DCD8AC8FDA8433D",
        false),
    User(
        'M. Naufal',
        '@mnaufal',
        "https://www.diethelmtravel.com/wp-content/uploads/2016/04/bill-gates-wealthiest-person-279x300.jpg",
        true),
  ];

  bool isFollowed = false;

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
                text: "Following",
              ),
              Tab(
                text: "Followers",
              )
            ],
          ),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "[Nama User]",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
        body: TabBarView(children: [
          //ini tab following
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('uid', isEqualTo: userProvider.getUser.uid)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: ijoSkripsi),
                  );
                }
                return snapshot.data!.docs.length == 0
                    ? Center(
                        child: Text(
                          "you haven't followed anyone",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: double.infinity,
                        width: double.infinity,
                        child: ListView.builder(
                          itemCount: _users.length,
                          itemBuilder: (context, index) {
                            final snap = snapshot.data!.docs[index].data();
                            return Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child:
                                                Image.network(snap['photoUrl']),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        //ini pal
                                        Text(
                                          snap['username'],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    //ini pal
                                    isFollowed
                                        ? InkWell(
                                            onTap: () {
                                              FirestoreMethods().followUser(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  widget.anotherUserId,
                                                  userToken.last);
                                              setState(() {
                                                isFollowed = false;
                                                followers--;
                                              });
                                            },
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: const Color(
                                                        0xFFeeeeee)),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: const Text(
                                                "Unfollow",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            )
                                            )
                                        : InkWell(
                                            onTap: () {
                                              FirestoreMethods().followUser(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  widget.anotherUserId,
                                                  userToken.last);
                                              setState(() {
                                                isFollowed = true;
                                                followers++;
                                              });
                                            },
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: const Color(
                                                        0xFFeeeeee)),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: const Text(
                                                "Follow",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            )),
                                  ],
                                ));
                          },
                        ),
                      );
              }),
              //ini tab followers(belom diapa apain, harusnya sama kayak yang following codingannya cuman bedanya ini buat followers)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: double.infinity,
            width: double.infinity,
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return userComponent(
                    name: _users[index].name,
                    username: _users[index].username,
                    image: _users[index].image,
                    isFollowed: _users[index].isFollowedByMe,
                    user: _users[index]);
              },
            ),
          ),
        ]),
      ),
    );
  }
}
//ini gajadi dipake
userComponent({name, username, image, isFollowed, required User user}) {
  return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(image),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: isFollowed ? const Color(0xFFeeeeee) : Color(0xffffff),
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: MaterialButton(
              onPressed: () {
                setState() {
                  user.isFollowedByMe = !user.isFollowedByMe;
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Text(
                isFollowed ? "Unfollow" : "Follow",
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ));
}

class User {
  final String name;
  final String username;
  final String image;
  bool isFollowedByMe;
  User(this.name, this.username, this.image, this.isFollowedByMe);
}
