import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/providers/user_provider.dart';
import 'package:cook_kuy/screens/card/home_following_card.dart';
import 'package:cook_kuy/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic userData = {};
  bool isLoading = false;

  getUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var data = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      setState(() {
        userData = data.data();
      });
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container()
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                titleSpacing: 4,
                elevation: 0,
                leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(userData['photoUrl']),
                    )),
                title: Text(
                  "Hi, ${userData['username']}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                actions: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.search,
                      color: ijoSkripsi,
                    ),
                  )
                ],
                backgroundColor: Colors.white,
              ),
              body: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot1) {
                  if (!snapshot1.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: ijoSkripsi,
                      ),
                    );
                  }
                  final userDoc = snapshot1.data;
                  List followingList = userDoc!.get('following');
                  return followingList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.people_alt,
                                size: 100,
                                color: Colors.grey[400],
                              ),
<<<<<<< HEAD
                            )
                          : ListView.builder(
=======
                              Text(
                                "there's no people you follow",
                                style: TextStyle(color: Colors.grey[400]),
                              )
                            ],
                          ),
                        )
                      : StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('recipe')
                              .where('uid', whereIn: followingList)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot2) {
                            final postLenght = snapshot2.data!.docs.length;
                            return ListView.builder(
>>>>>>> b79b3259844e9ab91848c853d7bd91644fbeeee9
                              padding: const EdgeInsets.only(bottom: 20),
                              itemCount: postLenght,
                              itemBuilder: (context, index) {
                                final recipeSnap =
                                    snapshot2.data!.docs[index].data();
                                    
                                // String followingPerUser = followingList[index];
                                return HomeFollowingCard(
                                    recipeSnap: recipeSnap);
                              },
                            );
                          },
                        );
                },
              ),
            ),
          );
  }
}

// followingList.isEmpty
//                       ? Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.people_alt,
//                                 size: 100,
//                                 color: Colors.grey[400],
//                               ),
//                               Text(
//                                 "there's no people you follow",
//                                 style: TextStyle(color: Colors.grey[400]),
//                               )
//                             ],
//                           ),
//                         )
//                       : 