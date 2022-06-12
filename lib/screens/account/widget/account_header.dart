import 'package:cook_kuy/screens/account/editprofile_screen.dart';
import 'package:cook_kuy/screens/account/widget/follow_following_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AccountHeader extends StatefulWidget {
  final String userProfilePict;
  final String username;
  final String bio;
  final List followers;
  final List following;
  const AccountHeader(
      {Key? key,
      required this.username,
      required this.userProfilePict,
      required this.bio,
      required this.followers,
      required this.following})
      : super(key: key);

  @override
  State<AccountHeader> createState() => _AccountHeaderState();
}

class _AccountHeaderState extends State<AccountHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(widget.userProfilePict),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.username,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  widget.bio,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 45.0),
              child: FollowAndFollowingWidget(
                count: widget.followers.length.toString(),
                labeltext: "Followers",
              ),
            ),
            const SizedBox(
              width: 25,
            ),
            const SizedBox(
              height: 40,
              child: VerticalDivider(
                color: Colors.black,
              ),
            ),
            const SizedBox(
              width: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 45.0),
              child: FollowAndFollowingWidget(
                count: widget.following.length.toString(),
                labeltext: "Following",
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfileScreen()),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
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
