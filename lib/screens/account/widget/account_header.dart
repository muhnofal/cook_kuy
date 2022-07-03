import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/screens/account/editprofile_screen.dart';
import 'package:cook_kuy/screens/account/widget/follow_following_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../router.dart';

class AccountHeader extends StatefulWidget {
  final String uid;

  const AccountHeader({Key? key, required this.uid}) : super(key: key);

  @override
  State<AccountHeader> createState() => _AccountHeaderState();
}

class _AccountHeaderState extends State<AccountHeader> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("ini userId: ${widget.uid}");
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .snapshots(),
        builder: (context, snapshot) {
          print("ini ${snapshot.data}");
          if (!snapshot.hasData) {
            return Container();
          }
          final userData = snapshot.data;
          return Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(userData!['photoUrl']),
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
                            userData['username'],
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            userData['bio'],
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
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(
                              AppRouter.followingandfollowers,
                            );
                          },
                          child: FollowAndFollowingWidget(
                            count: userData['followers'].length.toString(),
                            labeltext: "Followers",
                          ),
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
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(
                              AppRouter.followingandfollowers,
                            );
                          },
                          child: FollowAndFollowingWidget(
                            count: userData['following'].length.toString(),
                            labeltext: "Following",
                          ),
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
                              Navigator.of(context, rootNavigator: true)
                                  .pushNamed(AppRouter.editProfile);
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
              ),
            ),
          );
        });
  }
}
