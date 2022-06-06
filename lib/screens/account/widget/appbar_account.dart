import 'package:cook_kuy/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AppbarAccount extends StatefulWidget {
  const AppbarAccount({Key? key}) : super(key: key);

  @override
  State<AppbarAccount> createState() => _AppbarAccountState();
}

class _AppbarAccountState extends State<AppbarAccount> {
  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        "Account",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.settings,
            color: ijoSkripsi,
          ),
        )
      ],
    );
  }
}
