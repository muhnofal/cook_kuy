import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/model/user.dart';
import 'package:cook_kuy/providers/user_provider.dart';
import 'package:cook_kuy/resources/firestore_methods.dart';
import 'package:cook_kuy/screens/router.dart';
import 'package:cook_kuy/utils/colors.dart';
import 'package:cook_kuy/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class ApprovalDetailAdmin extends StatefulWidget {
  final String recipeId;

  const ApprovalDetailAdmin({Key? key, required this.recipeId})
      : super(key: key);

  @override
  State<ApprovalDetailAdmin> createState() => _ApprovalDetailAdminState();
}

class _ApprovalDetailAdminState extends State<ApprovalDetailAdmin> {
  bool isLoading = false;

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
      bottomSheet: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('approval')
              .doc(widget.recipeId)
              .snapshots(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return Container();
            }
            var data = snap.data;
            String recipeId = data!['recipe_id'];
            String recipeName = data['name'];
            String recipeDescription = data['description'];
            String recipeMainIngre = data['main_ingredient'];
            List<String> recipeIngre = List<String>.from(data['ingredients'] as List);
            String recipeImageUrl = data['image_url'];
            List<String> like = List<String>.from(data['like'] as List);
            List<Map<String, dynamic>> step = List<Map<String, dynamic>>.from(data['step'] as List);
            List<String> favorite = List<String>.from(data['favorite'] as List);
            String uid = data['uid'];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300]!,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          FirestoreMethods().updateApprovalStatus(recipeId, "Rejected");
                          Navigator.pop(context);
                        },
                        child: const Text("Reject"),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        startLoading(context);
                        uploadRecipe(
                            recipeId,
                            recipeName,
                            recipeDescription,
                            recipeMainIngre,
                            recipeIngre,
                            recipeImageUrl,
                            like,
                            step,
                            favorite,
                            uid);
                        FirestoreMethods().updateApprovalStatus(recipeId, "Accepted");
                        Navigator.pop(context);
                      },
                      child: const Text("Accept"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        primary: ijoSkripsi,
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  Widget divider() {
    return Divider(
      color: Colors.grey[200],
      thickness: 8,
    );
  }

  void uploadRecipe(
      String recipeId,
      String name,
      String description,
      String mainIngre,
      List<String> additionalIngre,
      String photoUrl,
      List<String> like,
      List<Map<String, dynamic>> step,
      List<String> favorite,
      String uid) async {
    setState(() {
      isLoading = true;
    });

    print('ini adalah data: $recipeId, $name, $description, $mainIngre');

    try {
      String res = await FirestoreMethods().uploadRecipe(
          recipeId,
          name,
          description,
          mainIngre,
          additionalIngre,
          photoUrl,
          like,
          step,
          favorite,
          uid,
          "Accepted");
      if (res == "success") {
        setState(() {
          isLoading = false;
          stopLoading(context);
        });
        showSnackBar('Your accepted this recipe', context);
      } else {
        showSnackBar(res, context);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        showSnackBar(e.toString(), context);
      });
    }
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
              separatorBuilder: (context, index) => const SizedBox(
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
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                // fit
                                image: NetworkImage(step[index]['image'])),
                            borderRadius: BorderRadius.circular(20)),
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
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(userData!['photoUrl']),
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
                                Text(
                                  userData['username'],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            approval,
                            style: TextStyle(
                                color: approval == "Pending"
                                    ? kuningSkripsi
                                    : approval == "Approved"
                                        ? ijoSkripsi
                                        : Colors.redAccent),
                          )
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
}
