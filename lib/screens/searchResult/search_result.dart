import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/screens/card/search_result_card.dart';
import 'package:cook_kuy/screens/cookScreen/additional_ingre_screen.dart';
import 'package:cook_kuy/screens/router.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SearchResultScreen extends StatefulWidget {
  final CompleteIngre completeIngre;
  const SearchResultScreen({Key? key, required this.completeIngre})
      : super(key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Result"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder(
          stream:
              // FirebaseFirestore.instance
              //     .collection('recipe')
              //     .where('ingredients', arrayContainsAny: widget.selectedIngredients)
              //     .snapshots(),
              widget.completeIngre.additionalIngre.isEmpty?
              FirebaseFirestore.instance.collection('recipe').where('main_ingredient', isEqualTo: widget.completeIngre.mainIngre).snapshots() : 
              FirebaseFirestore.instance.collection('recipe').where('main_ingredient', isEqualTo: widget.completeIngre.mainIngre).where('ingredients', arrayContainsAny: widget.completeIngre.additionalIngre).snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(
              children: [
                // Padding(
                //   padding:
                //       const EdgeInsets.only(left: 15, right: 15, top: 10),
                //   child: SizedBox(
                //     height: 40,
                //     child: ListView(
                //       scrollDirection: Axis.horizontal,
                //       children: [
                //         FilterChip(
                //             selected: true,
                //             label: const Text("Sarapan"),
                //             onSelected: (_) {}),
                //         const SizedBox(
                //           width: 10,
                //         ),
                //         FilterChip(
                //             selected: true,
                //             label: const Text("Makan Siang"),
                //             onSelected: (_) {}),
                //         const SizedBox(
                //           width: 10,
                //         ),
                //         FilterChip(
                //             selected: true,
                //             label: const Text("Makan Malam"),
                //             onSelected: (_) {})
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(
                        bottom: 15, left: 15, right: 15),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.80,
                            crossAxisSpacing: 25,
                            mainAxisSpacing: 25),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed(AppRouter.recipeDetail, arguments: snapshot.data!.docs[index].data());
                      },
                      child: SearchResultCard(
                          snap: snapshot.data!.docs[index].data()),
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}
