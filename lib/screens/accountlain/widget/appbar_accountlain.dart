import 'package:cook_kuy/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AppbarAccountLain extends StatefulWidget {
  const AppbarAccountLain({Key? key}) : super(key: key);

  @override
  State<AppbarAccountLain> createState() => _AppbarAccountLainState();
}

class _AppbarAccountLainState extends State<AppbarAccountLain> {
  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      automaticallyImplyLeading: true,
      iconTheme: IconThemeData(color: Colors.black),
      pinned: true,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        "Profile",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    );
  }
}
