import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/screens/card/ingredient_card.dart';
import 'package:cook_kuy/screens/router.dart';
import 'package:cook_kuy/utils/colors.dart';
import 'package:flutter/material.dart';

class CookScreen extends StatefulWidget {
  const CookScreen({Key? key}) : super(key: key);

  @override
  State<CookScreen> createState() => _CookScreenState();
}

class _CookScreenState extends State<CookScreen> {
  final controller = TextEditingController();
  String searchQuery = '';
  String selectedIngredient = "";
  String ingredientName = '';
  List test = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: StreamBuilder(
        stream: ingredientName.isNotEmpty
            ? FirebaseFirestore.instance
                .collection('ingredients')
                .where('search_keywords', arrayContains: ingredientName)
                .snapshots()
            : FirebaseFirestore.instance.collection('ingredients').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Choose one main ingredients",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: ijoSkripsi),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "The main ingredient is the basic ingredient for making a food",
                  textAlign: TextAlign.center,
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
                        // filled: true,
                        // fillColor: const Color.fromARGB(255, 238, 238, 238),
                        contentPadding: const EdgeInsets.all(8),
                        // suffixIcon: controller.text.isNotEmpty
                        //     ? GestureDetector(
                        //         child: const Icon(
                        //           Icons.close,
                        //           color: Colors.grey,
                        //         ),
                        //         onTap: () {
                        //           // controller.clear();
                        //           controller.text = '';
                        //           FocusScope.of(context)
                        //               .requestFocus(FocusNode());
                        //         },
                        //       )
                        //     : null,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        hintText: ('search ingredients'),
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
                            // if (selectedIngredient.length <= 1 - 1) {
                            //   isSelected
                            //       ? selectedIngredient
                            //           .remove(ingredients['name'])
                            //       : selectedIngredient.add(ingredients['name']);
                            // } else {
                            //   selectedIngredient.remove(ingredients['name']);
                            // }
                            selectedIngredient.isEmpty
                                ? selectedIngredient = ingredients['name']
                                : selectedIngredient = "";
                          });
                        },
                        child: IngredientCard(
                          snap: snapshot.data!.docs[index].data(),
                          isSelected: isSelected,
                          // onSelectedIngredients: selectedIngre
                        ),
                      );
                    },
                  ),
                ),
                selectedIngredient.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                            height: 45,
                            width: 150,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    primary: ijoSkripsi),
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: false)
                                      .pushNamed(AppRouter.additionalIngre,
                                          arguments: selectedIngredient);
                                },
                                child: const Text("Next step"))),
                      )
                    : Container()
              ],
            ),
          );
        },
      )),
    );
  }
}
