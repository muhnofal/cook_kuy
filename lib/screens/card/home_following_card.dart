import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/screens/router.dart';
import 'package:cook_kuy/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class HomeFollowingCard extends StatefulWidget {
  final dynamic recipeSnap;
  const HomeFollowingCard({Key? key, required this.recipeSnap})
      : super(key: key);

  @override
  State<HomeFollowingCard> createState() => _HomeFollowingCardState();
}

class _HomeFollowingCardState extends State<HomeFollowingCard> {
  // var userData = {};
  // getanotherUserData() async {
  //   try {
  //     var userSnap = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(widget.recipeSnap['uid'])
  //         .get();

  //     userData = userSnap.data()!;
  //     setState(() {});
  //   } catch (e) {
  //     showSnackBar(
  //       e.toString(),
  //       context,
  //     );
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   getRecipe();
  //   getUserData();
  //   print("ini index: ${widget.index}");
  //   print("ini list: ${recipeData.length}");
  // }

  @override
  Widget build(BuildContext context) {
    final List stepLength = widget.recipeSnap['step'];
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true)
            .pushNamed(AppRouter.recipeDetail, arguments: widget.recipeSnap);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // height: MediaQuery.of(context).size.height / 1.5,
          width: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
            // color:Colors.black,
            border: Border.all(color: const Color.fromARGB(255, 165, 165, 165)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.recipeSnap['uid'])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData){
                      return Container();
                    }
                    final userData = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(userData!['photoUrl']),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(userData['username'])
                        ],
                      ),
                    );
                  }),
              const SizedBox(
                height: 5,
              ),
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(widget.recipeSnap['image_url']),
                  fit: BoxFit.fitWidth,
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.recipeSnap['name']),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/Star.png",
                      height: 15,
                      width: 15,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 5),
                    Text(widget.recipeSnap['rating'].toString()),
                    const SizedBox(width: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(48),
                      child: Image.asset(
                        "assets/images/iconn.png",
                        height: 15,
                        width: 15,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text("${stepLength.length} Langkah"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ReadMoreText(
                  widget.recipeSnap['description'],
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  trimCollapsedText: "more",
                  trimExpandedText: "show less",
                  trimLines: 1,
                  trimMode: TrimMode.Line,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
