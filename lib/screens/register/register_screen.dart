import 'dart:typed_data';

import 'package:cook_kuy/resources/auth_methods.dart';
import 'package:cook_kuy/responsive/responsive_layout_screen.dart';
import 'package:cook_kuy/screens/login/login_screen.dart';
import 'package:cook_kuy/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../responsive/mobile_screen_layout.dart';
import '../../responsive/web_screen_layout.dart';
import '../../utils/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emaiController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  final imageDefault = 'https://www.personality-insights.com/wp-content/uploads/2017/12/default-profile-pic-e1513291410505.jpg';

  @override
  void dispose() {
    super.dispose();
    _emaiController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void registerUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().registerUser(
        email: _emaiController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        imageFile: imageDefault);

    setState(() {
      _isLoading = false;
    });

    if (res != "success") {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    }
  }

  void navigateToLogin() {
    // Navigator.of(context).pushNamed(AppRouter.login);
    // Navigator.of(context, rootNavigator: true).pushNamed(AppRouter.register);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 60,
              ),
              Column(
                children: const [
                  Text(
                    "CREATE ACCOUNT",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "create new account",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              // Stack(
              //   children: [
              //     _image != null
              //         ? CircleAvatar(
              //             radius: 80, backgroundImage: MemoryImage(_image!))
              //         : const CircleAvatar(
              //             radius: 70,
              //             backgroundImage: NetworkImage(
              //                 'https://www.personality-insights.com/wp-content/uploads/2017/12/default-profile-pic-e1513291410505.jpg')),
              //     Positioned(
              //       // top: 1,
              //       bottom: -0.10,
              //       left: 100,
              //       // child: IconButton(
              //       //   onPressed: selectImage,
              //       //   icon: const Icon(
              //       //     Icons.add_a_photo,
              //       //     color: ijoSkripsi,
              //       //   ),
              //       // ),
              //       child: InkWell(
              //         onTap: selectImage,
              //         child: const CircleAvatar(
              //           radius: 20,
              //           backgroundColor: ijoSkripsi,
              //           child: Icon(
              //             Icons.add_a_photo,
              //             color: Colors.white,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: double.infinity,
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
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Username",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  controller: _usernameController,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: double.infinity,
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
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  controller: _emaiController,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: double.infinity,
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
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  obscureText: true,
                  controller: _passwordController,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    primary: ijoSkripsi,
                  ),
                  onPressed: registerUser,
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "CREATE ACCOUNT",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have a account?"),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: navigateToLogin,
                    child: const Text(
                      "login",
                      style: TextStyle(color: ijoSkripsi),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
