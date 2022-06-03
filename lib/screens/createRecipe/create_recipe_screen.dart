import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({Key? key}) : super(key: key);

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Write a recipe",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 30,
            ),
            Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Recipe Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      maxLines: 5,
                      controller: controller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none),
                          hintText: "Write your recipe name here...",
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 189, 189, 189),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 228, 228, 228)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 10,
                      // width: 300,
                      color: const Color.fromARGB(255, 228, 228, 228)),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Recipe Description",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      maxLines: 5,
                      controller: controller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none),
                          hintText: "Examples: This is the best omelette ever",
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 189, 189, 189),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 228, 228, 228)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 10,
                      // width: 300,
                      color: const Color.fromARGB(255, 228, 228, 228)),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Main Ingredients",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.list_outlined),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        // padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          maxLines: 1,
                          controller: controller,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none),
                              hintText: "Examples: Egg",
                              hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 189, 189, 189),
                              ),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 228, 228, 228)),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.cancel_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.list_outlined),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        // padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          maxLines: 1,
                          controller: controller,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none),
                              hintText: "Examples: Egg",
                              hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 189, 189, 189),
                              ),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 228, 228, 228)),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.cancel_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.list_outlined),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        // padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          maxLines: 1,
                          controller: controller,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none),
                              hintText: "Examples: Egg",
                              hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 189, 189, 189),
                              ),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 228, 228, 228)),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.cancel_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ijoSkripsi,
                      ),
                      child: TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                          ),
                          onPressed: () {},
                          child: const Text("Add More Ingredients")),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 10,
                      // width: 300,
                      color: const Color.fromARGB(255, 228, 228, 228)),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Step by step",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Make sure the picture you've taken are clear",
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Step 1"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 228, 228, 228),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.camera_alt_rounded),
                            color: const Color.fromARGB(255, 189, 189, 189),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.4,
                          // padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            maxLines: 1,
                            controller: controller,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none),
                                hintText: "Examples: Egg",
                                hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 189, 189, 189),
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 228, 228, 228)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Step 2"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 228, 228, 228),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.camera_alt_rounded),
                            color: const Color.fromARGB(255, 189, 189, 189),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.4,
                          // padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            maxLines: 1,
                            controller: controller,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none),
                                hintText: "Examples: Egg",
                                hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 189, 189, 189),
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 228, 228, 228)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Step 3"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 228, 228, 228),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.camera_alt_rounded),
                            color: const Color.fromARGB(255, 189, 189, 189),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.4,
                          // padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            maxLines: 1,
                            controller: controller,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none),
                                hintText: "Examples: Egg",
                                hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 189, 189, 189),
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 228, 228, 228)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ijoSkripsi,
                      ),
                      child: TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                          ),
                          onPressed: () {},
                          child: const Text("Add More Steps")),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 10,
                      // width: 300,
                      color: const Color.fromARGB(255, 228, 228, 228)),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Recipe Photos",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Make sure the picture you've taken are clear",
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.5,
                    color: const Color.fromARGB(255, 228, 228, 228),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt_rounded),
                      iconSize: 120,
                      color: const Color.fromARGB(255, 189, 189, 189),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                 Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ijoSkripsi,
                      ),
                      child: TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                          ),
                          onPressed: () {},
                          child: const Text("Upload Recipe")),
                    ),
                  ),
                  const SizedBox(height: 40,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
