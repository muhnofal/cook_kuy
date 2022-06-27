import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/resources/firestore_methods.dart';
import 'package:cook_kuy/utils/colors.dart';
import 'package:cook_kuy/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  Uint8List? _image;

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        backgroundColor: Colors.white,
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        // actions: [
        //   TextButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     child: const Text(
        //       "Done",
        //       style: TextStyle(
        //         color: Colors.blue,
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final userData = snapshot.data;
            _usernameController =
                TextEditingController(text: userData!['username']);
            _bioController = TextEditingController(text: userData['bio']);
            return ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Column(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  NetworkImage(userData['photoUrl']),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: selectImage,
                        child: const Text(
                          "Change profile photo",
                          style: TextStyle(
                            color: ijoSkripsi,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Username",
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        controller: _usernameController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Bio",
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        controller: _bioController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            editProfileLoading(context);
                            // setState(() {
                            //   isLoading = true;
                            // });
                            var profileUrl = userData['photoUrl'];
                            http.Response response = await http.get(Uri.parse(profileUrl));
                            try {
                              String res = _image != null ? await FirestoreMethods().editProfile(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  _usernameController.text,
                                  _bioController.text,
                                  _image!) : await FirestoreMethods().editProfile(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  _usernameController.text,
                                  _bioController.text,
                                  response.bodyBytes);
                              print('ini res: $res');
                              if (res == "success") {
                                setState(() {
                                  // isLoading = false;
                                  stopLoading(context);
                                  Navigator.pop(context);
                                });
                              } else {
                                showSnackBar(res, context);
                              }
                            } catch (e) {
                              showSnackBar(e.toString(), context);
                            }
                          },
                          child: const Text(
                            "Change Profile",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            primary: ijoSkripsi,
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
