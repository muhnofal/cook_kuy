import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/providers/user_provider.dart';
import 'package:cook_kuy/resources/firestore_methods.dart';
import 'package:cook_kuy/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';

class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({Key? key}) : super(key: key);

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  //controller
  final recipeNameController = TextEditingController();
  final recipeDescriptionController = TextEditingController();
  final stepController = TextEditingController();
  final mainIngreController = TextEditingController();
  final additioalIngreController = TextEditingController();
  final List<TextEditingController> _additionalIngreListcontroller = [];
  final List<TypeAheadField> _textFieldInput = [];
  late TextEditingController alertController;
  late TextEditingController editStepController;

  List _allIngredients = [];
  late Future resultsLoaded;
  List<Map<String, dynamic>> allStep = [];
  Uint8List? _image;
  Uint8List? _recipePhoto;

  bool isLoading = false;

  _addInputField(context) {
    final inputController = TextEditingController();
    final inputField = _generateInputField(inputController);

    setState(() {
      _additionalIngreListcontroller.add(inputController);
      _textFieldInput.add(inputField);
    });
  }

  _generateInputField(inputController) {
    return TypeAheadField<String>(
      textFieldConfiguration: TextFieldConfiguration(
        autofocus: false,
        maxLines: 1,
        controller: inputController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none),
          hintText: "Examples: Egg",
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 189, 189, 189),
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 228, 228, 228),
        ),
      ),
      hideOnEmpty: false,
      noItemsFoundBuilder: (context) => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("No ingredients. Please use the suggestion"),
      ),
      suggestionsCallback: (pattern) async {
        return await searchData(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      onSuggestionSelected: (suggestion) {
        inputController.text = suggestion;
      },
    );
  }

  getIngredinetsData() async {
    var data = await FirebaseFirestore.instance
        .collection('ingredients')
        .where('name')
        .get();

    setState(() {
      _allIngredients = data.docs;
    });

    return "sucess";
  }

  Future searchData(String param) async {
    List<String> allData = [];
    for (var element in _allIngredients) {
      allData.add(element['name']);
    }
    List<String> result = allData
        .where((element) => element.toLowerCase().contains(param.toLowerCase()))
        .toList();
    return result;
  }

  Future deleteStepAlert() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Delete Step?"),
          content: const Text("Are you sure want to delete this step?"),
          actions: [
            InkWell(
              onTap: () =>
                  Navigator.of(context, rootNavigator: true).pop(false),
              child: const Text(
                "CANCEL",
                style: TextStyle(color: ijoSkripsi),
              ),
            ),
            InkWell(
              onTap: () => Navigator.of(context, rootNavigator: true).pop(true),
              child: const Text(
                "DELETE",
                style: TextStyle(color: ijoSkripsi),
              ),
            )
          ],
        ),
      );

  Future createNewStep() => showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                "Tell the process",
                textAlign: TextAlign.center,
                style: TextStyle(color: ijoSkripsi),
              ),
              content: SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () async {
                        Uint8List image = await pickImage(ImageSource.gallery);
                        setState(() {
                          _image = image;
                        });
                      },
                      child: _image != null
                          ? Container(
                              width: double.infinity / 2,
                              height: 150,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  image: DecorationImage(
                                      fit: BoxFit.fitHeight,
                                      image: MemoryImage(_image!))),
                            )
                          : Container(
                              width: double.infinity / 2,
                              height: 160,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                              ),
                              child: const Center(
                                  child: Text(
                                "Click here to add image",
                                style: TextStyle(color: Colors.grey),
                              )),
                            ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.infinity / 2,
                      child: TextField(
                          minLines: 5,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: "Write recipe description here...",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          controller: alertController),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      primary: kuningSkripsi,
                      shadowColor: Colors.transparent),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    alertController.text = "";
                    _image = null;
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      primary: ijoSkripsi,
                      shadowColor: Colors.transparent),
                  onPressed: done,
                  child: const Text("Done"),
                ),
              ],
            );
          },
        ),
      );

  Future editStep(Uint8List image, String description) => showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            editStepController.text = description;
            return AlertDialog(
              title: const Text(
                "Tell the process",
                textAlign: TextAlign.center,
                style: TextStyle(color: ijoSkripsi),
              ),
              content: SizedBox(
                width: 300,
                height: 300,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        Uint8List image2 = await pickImage(ImageSource.gallery);
                        setState(() {
                          image = image2;
                        });
                      },
                      child: Container(
                        width: double.infinity / 2,
                        height: 150,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            image: DecorationImage(
                                fit: BoxFit.fitHeight,
                                image: MemoryImage(image))),
                      ),
                    ),
                    Container(
                      width: double.infinity / 2,
                      // height: 180,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        // border
                      ),
                      child: TextField(
                          minLines: 5,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: "Write recipe description here...",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          controller: editStepController),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      primary: kuningSkripsi,
                      shadowColor: Colors.transparent),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      primary: ijoSkripsi,
                      shadowColor: Colors.transparent),
                  onPressed: () {
                    List<Map<String, dynamic>> data = [
                      {'image': image, 'description': editStepController.text},
                    ];
                    Navigator.of(context, rootNavigator: true).pop(data);
                    alertController.clear();
                    _image = null;
                  },
                  child: const Text("Done"),
                ),
              ],
            );
          },
        ),
      );

  void uploadRecipe(String uid) async {
    setState(() {
      isLoading = true;
    });

    List<String> additionalIngre = [];
    List<Map<String, dynamic>> stepBystepList = [];

    additionalIngre.add(additioalIngreController.text);
    for (TextEditingController element in _additionalIngreListcontroller) {
      additionalIngre.add(element.text);
    }

    for (Map<String, dynamic> step in allStep) {
      stepBystepList.add(step);
    }

    try {
      String res = await FirestoreMethods().uploadRecipe(
          recipeNameController.text,
          recipeDescriptionController.text,
          mainIngreController.text,
          additionalIngre,
          _recipePhoto!,
          [],
          stepBystepList,
          [],
          uid,);
      if (res == "success") {
        setState(() {
          isLoading = false;
          stopLoading(context);
        });
        showSnackBar('Success to upload recipe', context);
        clearForm();
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

  void clearForm() {
    setState(() {
      recipeNameController.clear();
      recipeDescriptionController.clear();
      mainIngreController.clear();
      _additionalIngreListcontroller.clear();
      allStep.clear();
      additioalIngreController.clear();
      _recipePhoto = null;
    });
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _recipePhoto = image;
    });
  }

  void done() {
    List<Map<String, dynamic>> data = [
      {'image': _image, 'description': alertController.text},
    ];
    Navigator.of(context, rootNavigator: true).pop(data);
    alertController.clear();
    _image = null;
  }

  editDone(Uint8List image, String description) {
    List<Map<String, dynamic>> data = [
      {'image': image, 'description': description},
    ];
    Navigator.of(context, rootNavigator: true).pop(data);
    alertController.clear();
    _image = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getIngredinetsData();
  }

  @override
  void dispose() {
    alertController.dispose();
    editStepController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    alertController = TextEditingController();
    editStepController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Write a recipe",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 10,
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
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      maxLines: 5,
                      controller: recipeNameController,
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
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      maxLines: 5,
                      controller: recipeDescriptionController,
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
                    color: const Color.fromARGB(255, 228, 228, 228),
                  ),
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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Main ingredient is just 1",
                      style: TextStyle(color: ijoSkripsi),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TypeAheadField<String>(
                      textFieldConfiguration: TextFieldConfiguration(
                        autofocus: false,
                        maxLines: 1,
                        controller: mainIngreController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none),
                          hintText: "Examples: Meat",
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 189, 189, 189),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 228, 228, 228),
                        ),
                      ),
                      hideOnEmpty: false,
                      noItemsFoundBuilder: (context) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child:
                            Text("No ingredients. Please use the suggestion"),
                      ),
                      suggestionsCallback: (pattern) async {
                        return await searchData(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        mainIngreController.text = suggestion;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Additional Ingredients",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "You can only add 10 ingredients",
                      style: TextStyle(color: ijoSkripsi),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TypeAheadField<String>(
                        textFieldConfiguration: TextFieldConfiguration(
                          autofocus: false,
                          maxLines: 1,
                          controller: additioalIngreController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none),
                            hintText: "Examples: Chili",
                            hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 189, 189, 189),
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 228, 228, 228),
                          ),
                        ),
                        hideOnEmpty: false,
                        noItemsFoundBuilder: (context) => const Padding(
                          padding: EdgeInsets.all(8.0),
                          child:
                              Text("No ingredients. Please use the suggestion"),
                        ),
                        suggestionsCallback: (pattern) async {
                          return await searchData(pattern);
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          additioalIngreController.text = suggestion;
                        },
                      ),
                    ),
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _additionalIngreListcontroller.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: _textFieldInput.elementAt(index),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _additionalIngreListcontroller
                                      .removeAt(index);
                                  _textFieldInput.removeAt(index);
                                });
                              },
                              child: const Icon(
                                Icons.clear,
                                color: abuSkripsi,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  _additionalIngreListcontroller.length == 9
                      ? Container()
                      : Center(
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
                                onPressed: () {
                                  _addInputField(context);
                                },
                                child: const Text(
                                  "Add More Ingredients",
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                        ),
                  const SizedBox(
                    height: 20,
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
                      style: TextStyle(color: ijoSkripsi),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    itemCount: allStep.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Step ${index + 1}"),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromARGB(
                                          255, 228, 228, 228),
                                      image: DecorationImage(
                                          fit: BoxFit.fitWidth,
                                          image: MemoryImage(
                                              allStep[index]['image']))),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    // height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromARGB(
                                          255, 228, 228, 228),
                                    ),
                                    child: TextFormField(
                                      key: Key(allStep[index]['description']
                                          .toString()),
                                      autofocus: false,
                                      minLines: 1,
                                      maxLines: 5,
                                      initialValue:
                                          "${allStep[index]['description']}",
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () async {
                                    final mapData = await editStep(
                                        allStep[index]['image'],
                                        allStep[index]['description']);
                                    setState(
                                      () {
                                        allStep[index]['image'] =
                                            mapData[index]['image'];
                                        allStep[index]['description'] =
                                            mapData[index]['description'];
                                      },
                                    );
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: ijoSkripsi,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () async {
                                    final bool isDelete =
                                        await deleteStepAlert();
                                    if (isDelete == true) {
                                      setState(() {
                                        allStep.removeAt(index);
                                      });
                                    }
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: kuningSkripsi,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
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
                          onPressed: () async {
                            final mapData = await createNewStep();
                            setState(() {
                              allStep.addAll(mapData);
                            });
                          },
                          child: const Text("Add Step by step")),
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
                  _recipePhoto != null
                      ? InkWell(
                          onTap: selectImage,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 228, 228, 228),
                                image: DecorationImage(
                                    fit: BoxFit.fitHeight,
                                    image: MemoryImage(_recipePhoto!))),
                          ),
                        )
                      : InkWell(
                          onTap: selectImage,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            color: const Color.fromARGB(255, 228, 228, 228),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 120,
                              color: Color.fromARGB(255, 189, 189, 189),
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 50,
                  ),
                  // isLoading
                  //     ? const LinearProgressIndicator()
                  //     : const Padding(
                  //         padding: EdgeInsets.only(top: 0),
                  //       ),
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
                          onPressed: () {
                            startLoading(context);
                            uploadRecipe(
                              userProvider.getUser.uid,
                            );
                          },
                          child: const Text("Upload Recipe")),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StepByStep {
  final Uint8List image;
  final String description;

  StepByStep({required this.image, required this.description});
}
