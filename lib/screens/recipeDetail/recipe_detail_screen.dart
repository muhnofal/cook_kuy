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

class RecipeDetailScreen extends StatefulWidget {
  final dynamic snap;
  const RecipeDetailScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  var userData = {};

  getData() async {
    var snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap['uid'])
        .get();
    userData = snap.data()!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = widget.snap;
    return Scaffold(
      appBar: AppBar(
        title: Text(snapshot['name']),
        centerTitle: true,
        titleTextStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            recipeImage(snapshot),
            introduce(snapshot),
            divider(),
            rating(snapshot),
            divider(),
            ingredients(snapshot),
            divider(),
            stepByStep(snapshot),
            divider(),
            commentBar(snapshot),
            divider(),
            commentList(snapshot)
          ],
        ),
      ),
    );
  }

  Widget divider() {
    return Divider(
      color: Colors.grey[200],
      thickness: 8,
    );
  }

  Widget commentList(final snapshot) {
    User user = Provider.of<UserProvider>(context).getUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('recipe')
            .doc(widget.snap['recipe_id'])
            .collection('comments')
            .orderBy('date_published', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.separated(
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                final commentData = snapshot.data!.docs[index].data();
                List likesCounter = commentData['likes'];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            NetworkImage(commentData['profile_pic']),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              commentData['name'].toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(commentData['text']),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                InkWell(
                                    onTap: () async {
                                      await FirestoreMethods().likeComment(
                                          widget.snap['recipe_id'],
                                          commentData['comment_id'],
                                          commentData['uid'],
                                          commentData['likes']);
                                    },
                                    child: Icon(
                                      Icons.thumb_up,
                                      color: likesCounter.contains(user.uid)
                                          ? ijoSkripsi
                                          : Colors.grey,
                                    )),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  likesCounter.length.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600]),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Reply",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => Divider(
                    color: Colors.grey[200],
                    thickness: 3,
                  ),
              itemCount: snapshot.data!.docs.length);
        });
  }

  Widget commentBar(final snap) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(user.photoUrl),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                readOnly: true,
                onTap: showCommentField,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(10, 5.0, 20.0, 5.0),
                  hintText: "What do you think...?",
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
        ],
      ),
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

  Widget rating(final snap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Rate this recipe",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: RatingBar.builder(
                initialRating: 0,
                // minRating: 1,
                itemPadding: const EdgeInsets.symmetric(horizontal: 5),
                direction: Axis.horizontal,
                itemSize: 50,
                itemBuilder: ((context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    )),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget introduce(final snap) {
    final List step = snap['step'];
    Timestamp date = snap['date_published'];
    DateTime dateTime = date.toDate();
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('recipe')
            .doc(widget.snap['recipe_id'])
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: ijoSkripsi),
            );
          }

          var recipeDoc = snapshot.data;

          List favoriteList = recipeDoc!.get('favorite');
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pushNamed(
                            AppRouter.anotherAccount,
                            arguments: userData['uid']);
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(userData['photoUrl']),
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
                    InkWell(
                      splashFactory: NoSplash.splashFactory,
                      onTap: () async {
                        await FirestoreMethods().addFavorite(
                            widget.snap['recipe_id'],
                            userProvider.getUser.uid,
                            favoriteList);
                      },
                      child: Icon(Icons.favorite,
                          size: 45,
                          color: favoriteList.contains(userProvider.getUser.uid)
                              ? ijoSkripsi
                              : Colors.grey[400]),
                    )
                  ],
                ),
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
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: kuningSkripsi,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(snap['rating'].toString())
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
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

  void showCommentField() => showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          final MediaQueryData mediaQueryData = MediaQuery.of(context);
          final User user = Provider.of<UserProvider>(context).getUser;
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
                      widget.snap['recipe_id'],
                      _commentController.text,
                      user.uid,
                      user.username,
                      user.photoUrl, []);
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
