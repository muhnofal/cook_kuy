import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/screens/router.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../card/ingredient_card.dart';

class AdditionalIngreScreen extends StatefulWidget {
  final String mainIngre;
  const AdditionalIngreScreen({Key? key, required this.mainIngre})
      : super(key: key);

  @override
  State<AdditionalIngreScreen> createState() => _AdditionalIngreScreenState();
}

class _AdditionalIngreScreenState extends State<AdditionalIngreScreen> {
  final controller = TextEditingController();
  String searchQuery = '';
  List selectedIngredient = [];
  String ingredientName = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: StreamBuilder(
            stream: ingredientName.isNotEmpty
                ? FirebaseFirestore.instance
                    .collection('ingredients')
                    .where('search_keywords', arrayContains: ingredientName)
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection('ingredients')
                    .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Choose your additional ingredients (Max 10)",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: ijoSkripsi),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Almost done, now choose the additional ingredients",
                      textAlign: TextAlign.center,
                      // style: TextStyle(color: abuSkripsi),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      child: Container(
                        height: 50,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300]!,
                              offset: const Offset(
                                3.0,
                                6.0,
                              ), //Offset
                              blurRadius: 8.0,
                              // spreadRadius: 1.0,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(8),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                            hintText: ('Search Ingredients'),
                            hintStyle: TextStyle(
                                fontSize: 14, color: Colors.grey.shade500),
                          ),
                          onChanged: (value) {
                            setState(() {
                              value.isEmpty
                                  ? ingredientName = ""
                                  : ingredientName = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 300,
                      height: 350,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300]!,
                            offset: const Offset(
                              3.0,
                              6.0,
                            ), //Offset
                            blurRadius: 8.0,
                            // spreadRadius: 1.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final ingredients = snapshot.data!.docs[index].data();
                          final isSelected =
                              selectedIngredient.contains(ingredients['name']);
                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (selectedIngredient.length <= 9) {
                                  isSelected
                                      ? selectedIngredient
                                          .remove(ingredients['name'])
                                      : selectedIngredient
                                          .add(ingredients['name']);
                                } else {
                                  selectedIngredient
                                      .remove(ingredients['name']);
                                }
                              });
                            },
                            child: IngredientCard(
                              snap: snapshot.data!.docs[index].data(),
                              isSelected: isSelected,
                            ),
                          );
                        },
                      ),
                    ),
                    selectedIngredient.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                    height: 45,
                                    width: 150,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: const StadiumBorder(),
                                            primary: ijoSkripsi),
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: false)
                                              .pushNamed(AppRouter.searchResult,
                                                  arguments: CompleteIngre(
                                                      mainIngre:
                                                          widget.mainIngre,
                                                      additionalIngre:
                                                          selectedIngredient));
                                        },
                                        child: const Text("Search Recipe"))),
                                SizedBox(
                                  height: 45,
                                  width: 150,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: const StadiumBorder(),
                                          primary: Colors.grey[350]),
                                      onPressed: () {},
                                      child: Text(
                                        "${selectedIngredient.length} ingredients",
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      )),
                                )
                              ],
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              Navigator.of(context, rootNavigator: false)
                                  .pushNamed(AppRouter.searchResult,
                                      arguments: CompleteIngre(
                                          mainIngre: widget.mainIngre,
                                          additionalIngre: selectedIngredient));
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                "No need additional ingredients",
                                style: TextStyle(color: ijoSkripsi),
                              ),
                            ),
                          )
                  ],
                ),
              );
            },
          )),
    );
  }
}

class CompleteIngre {
  final String mainIngre;
  final List additionalIngre;

  CompleteIngre({required this.mainIngre, required this.additionalIngre});
}
