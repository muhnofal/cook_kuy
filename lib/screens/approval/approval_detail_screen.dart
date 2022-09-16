import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/model/user.dart';
import 'package:cook_kuy/providers/user_provider.dart';
import 'package:cook_kuy/resources/firestore_methods.dart';
import 'package:cook_kuy/screens/router.dart';
import 'package:cook_kuy/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class ApprovalDetailScreen extends StatefulWidget {
  final String recipeId;

  const ApprovalDetailScreen({Key? key, required this.recipeId})
      : super(key: key);

  @override
  State<ApprovalDetailScreen> createState() => _ApprovalDetailScreenState();
}

class _ApprovalDetailScreenState extends State<ApprovalDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Approval Detail"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('approval')
                .doc(widget.recipeId)
                .snapshots(),
            builder: (context, snap) {
              if (!snap.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              var snapshot = snap.data;
              return Column(
                children: [
                  recipeImage(snapshot),
                  introduce(snapshot),
                  divider(),
                  ingredients(snapshot),
                  divider(),
                  stepByStep(snapshot),
                ],
              );
            }),
      ),
    );
  }

  Widget divider() {
    return Divider(
      color: Colors.grey[200],
      thickness: 8,
    );
  }

  Widget stepByStep(final snapshot) {
    final List step = snapshot['step'];
    return Padding(
      // padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      padding: const EdgeInsets.only(top: 25, bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Step by step",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 350,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              separatorBuilder: (context, index) =>
              const SizedBox(
                width: 12,
              ),
              scrollDirection: Axis.horizontal,
              // shrinkWrap: true,
              itemCount: step.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(AppRouter.navrecipeDetail);
                        },
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  // fit
                                  image: NetworkImage(step[index]['image'])),
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Step ${index + 1}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        step[index]['description'].toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget recipeImage(final snap) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fitWidth,
          image: NetworkImage(snap['image_url']),
        ),
      ),
    );
  }

  Widget ingredients(final snap) {
    final List ingredients = snap['ingredients'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Main Ingredients",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Text("\u2022 ${snap['main_ingredient']}"),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Ingredients",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                return Text("\u2022 ${ingredients[index]}");
              },
              itemCount: ingredients.length),
        ],
      ),
    );
  }

  Widget introduce(final snap) {
    final List step = snap['step'];
    Timestamp date = snap['date_published'];
    DateTime dateTime = date.toDate();
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final approval = snap['approval_status'];

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('approval')
            .doc(widget.recipeId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: ijoSkripsi),
            );
          }

          var recipeDoc = snapshot.data;

          List likeList = recipeDoc!.get('like');
          String userId = recipeDoc.get('uid');
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .snapshots(),
                    builder: (context, userSnap) {
                      if (!userSnap.hasData) {
                        return Container();
                      }
                      final userData = userSnap.data;
                      return Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pushNamed(AppRouter.anotherAccount,
                                  arguments: userData!['uid']);
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                              NetworkImage(userData!['photoUrl']),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('dd MMMM yyyy').format(dateTime),
                                  style: const TextStyle(color: abuSkripsi),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pushNamed(AppRouter.anotherAccount);
                                  },
                                  child: Text(
                                    userData['username'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(approval, style: TextStyle(
                              color: approval == "Pending"
                                  ? kuningSkripsi
                                  : approval == "Accepted"
                                  ? ijoSkripsi
                                  : Colors.redAccent),)
                        ],
                      );
                    }),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  snap['name'],
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    // Row(
                    //   children: [
                    //     const Icon(
                    //       Icons.star,
                    //       color: kuningSkripsi,
                    //     ),
                    //     const SizedBox(
                    //       width: 5,
                    //     ),
                    //     Text(snap['rating'].toString())
                    //   ],
                    // ),
                    // const SizedBox(
                    //   width: 20,
                    // ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/step_icon.png',
                          width: 22,
                          height: 22,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(("${step.length} step"))
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ReadMoreText(
                  snap['description'],
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Read More',
                  trimExpandedText: 'Read Less',
                  style: const TextStyle(color: Colors.black),
                  lessStyle: const TextStyle(color: ijoSkripsi),
                  moreStyle: const TextStyle(color: ijoSkripsi),
                )
              ],
            ),
          );
        });
  }

  void showCommentField() =>
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          final MediaQueryData mediaQueryData = MediaQuery.of(context);
          final User user = Provider
              .of<UserProvider>(context)
              .getUser;
          return Padding(
            // padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
            padding: mediaQueryData.viewInsets,
            child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              title: TextField(
                autofocus: true,
                maxLines: 3,
                minLines: 1,
                decoration: InputDecoration(
                  contentPadding:
                  const EdgeInsets.fromLTRB(10, 10.0, 20.0, 10.0),
                  hintText: "What do you think...?",
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  // fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10)),
                ),
                controller: _commentController,
              ),
              trailing: InkWell(
                onTap: () async {
                  await FirestoreMethods().postComment(
                      widget.recipeId,
                      _commentController.text,
                      user.uid,
                      user.username,
                      user.photoUrl,
                      [],
                      'comment');
                  _commentController.clear();
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.send,
                  color: ijoSkripsi,
                ),
              ),
            ),
          );
        },
      );
}
