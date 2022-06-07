import 'package:cook_kuy/resources/auth_methods.dart';
import 'package:cook_kuy/screens/register/register_screen.dart';
import 'package:cook_kuy/screens/router.dart';
import 'package:cook_kuy/utils/colors.dart';
import 'package:cook_kuy/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../responsive/mobile_screen_layout.dart';
import '../../responsive/responsive_layout_screen.dart';
import '../../responsive/web_screen_layout.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emaiController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isloading = false;

  @override
  void dispose() {
    super.dispose();
    _emaiController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isloading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emaiController.text, password: _passwordController.text);

    print("ini res $res");

    if (res == "success") {
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (_) => const ResponsiveLayout(
      //       webScreenLayout: WebScreenLayout(),
      //       mobileScreenLayout: MobileScreenLayout(),
      //     ),
      //   ),
      // );
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isloading = false;
    });
  }

  void navigateToRegister() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 60,
                ),
                Image.asset(
                  'assets/images/cook_kuy_logo.png',
                  width: 200,
                  height: 200,
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
                      // filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    controller: _passwordController,
                    obscureText: true,
                  ),
                ),
                const SizedBox(
                  height: 15,
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
                    onPressed: loginUser,
                    child: _isloading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "LOGIN",
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
                    const Text("Don't have account?"),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: navigateToRegister,
                      child: const Text(
                        "create a new account",
                        style: TextStyle(color: ijoSkripsi),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
