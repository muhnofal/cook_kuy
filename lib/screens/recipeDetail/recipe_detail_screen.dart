import 'package:cook_kuy/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readmore/readmore.dart';

class RecipeDetailScreen extends StatefulWidget {
  final dynamic snap;
  const RecipeDetailScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  String imageTemp =
      'https://firebasestorage.googleapis.com/v0/b/cook-kuy-53f5f.appspot.com/o/temp%2Ftelur%20rebus%20balado.png?alt=media&token=504da76d-b983-45e3-8c0e-89628d8e29c6';
  String imageTemp2 =
      "https://firebasestorage.googleapis.com/v0/b/cook-kuy-53f5f.appspot.com/o/profilePics%2FU3zkeCfTJcZwOPZuGaQ20EN9Ppq2?alt=media&token=f16b0716-f231-4c4e-ab0c-07f6f5f7881b";
  String imageTemp3 =
      "https://firebasestorage.googleapis.com/v0/b/cook-kuy-53f5f.appspot.com/o/temp%2Frebus%20telur.png?alt=media&token=61f428c0-f9b7-4a8e-87d7-6475708310c2";
  List ingredientsTemp = [
    'telur',
    'cabai',
    'bawang merah',
    'bawang putih',
    'bawang putih',
    'bawang putih'
  ];
  final TextEditingController _commentController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   _commentController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final snapshot = widget.snap;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Telur Rebus Balado"),
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
    return ListView.separated(
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(imageTemp2),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Bambang",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                          "Makananya sangat enak banget gan, wajib dicoba gess"),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          InkWell(
                              onTap: () {},
                              child: const Icon(
                                Icons.thumb_up,
                                color: Colors.grey,
                              )),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "0",
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
        itemCount: 5);
  }

  Widget commentBar(final snap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(imageTemp2),
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
              itemCount: 10,
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
                                image: NetworkImage(imageTemp3)),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Step ${index + 1}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "jvhjjmbjbjkbjkbkkggiugiugiuugiugguvhjjeqweasdasdasdasdasdasddasdaasdasd",
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ingredients",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 15,
          ),
          ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              return Text("\u2022 ${ingredientsTemp[index]}");
            },
            itemCount: ingredientsTemp.length,
          ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(imageTemp2),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "26 April 2022",
                    style: TextStyle(color: abuSkripsi),
                  ),
                  Text("Bambang"),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            snap['name'],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  const Text("3 Langkah")
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
  }

  void showCommentField() => showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        final MediaQueryData mediaQueryData = MediaQuery.of(context);
        return Padding(
          // padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
          padding: mediaQueryData.viewInsets,
          child: ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(imageTemp2),
            ),
            title: TextField(
              autofocus: true,
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(10, 10.0, 20.0, 10.0),
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
            trailing: const Icon(
              Icons.send,
              color: ijoSkripsi,
            ),
          ),
        );
      });
}
