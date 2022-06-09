import 'package:cook_kuy/screens/account/settings_screen.dart';
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
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: const Text(
        "Account",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.settings,
              color: ijoSkripsi,
            ),
          ),
        )
      ],
    );
  }
}
