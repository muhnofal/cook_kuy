import 'package:cook_kuy/screens/account/widget/follow_following_widget.dart';
import 'package:cook_kuy/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AccountHeaderLain extends StatefulWidget {
  const AccountHeaderLain({Key? key}) : super(key: key);

  @override
  State<AccountHeaderLain> createState() => _AccountHeaderLainState();
}

class _AccountHeaderLainState extends State<AccountHeaderLain> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage("assets/images/person.png"),
            ),
            FollowAndFollowingWidget(
              count: "10",
              labeltext: "Recipe",
            ),
            FollowAndFollowingWidget(
              count: "360",
              labeltext: "Followers",
            ),
            FollowAndFollowingWidget(
              count: "240",
              labeltext: "Following",
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "RavyAryo",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                "My favorite ingredients is egg",
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: ijoSkripsi,
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    "Follow",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
