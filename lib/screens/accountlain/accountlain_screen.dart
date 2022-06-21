import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/screens/account/widget/persistent_header.dart';
import 'package:cook_kuy/screens/accountlain/widget/accountlain_header.dart';
import 'package:cook_kuy/screens/accountlain/widget/appbar_accountlain.dart';
import 'package:cook_kuy/screens/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../utils/colors.dart';

class AccountLain extends StatefulWidget {
  final String anotherUserId;
  const AccountLain({Key? key, required this.anotherUserId}) : super(key: key);

  @override
  State<AccountLain> createState() => _AccountLainState();
}

class _AccountLainState extends State<AccountLain> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: NestedScrollView(
        headerSliverBuilder: (context, index) {
          return [
            const AppbarAccountLain(),
            SliverToBoxAdapter(
              child: AccountHeaderLain(anotherUserId: widget.anotherUserId),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: PersistentHeader(
                child: const Material(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Text(
                      "User Recipe",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            )
          ];
        },
        body: Material(
          child: TabBarView(
            children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('recipe')
                      .where('uid', isEqualTo: widget.anotherUserId)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: ijoSkripsi),
                      );
                    }
                    return snapshot.data!.docs.length == 0
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.soup_kitchen_rounded,
                                  size: 100,
                                  color: Colors.grey[400],
                                ),
                                Text(
                                  "you haven't posted",
                                  style: TextStyle(color: Colors.grey[400]),
                                )
                              ],
                            ),
                          )
                        : CustomScrollView(
                            physics: const ClampingScrollPhysics(),
                            slivers: [
                              SliverGrid(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final snap =
                                          snapshot.data!.docs[index].data();
                                      return InkWell(
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pushNamed(AppRouter.recipeDetail,
                                                  arguments: snap['recipe_id']);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  snap['image_url']),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    childCount: snapshot.data!.docs.length,
                                  ),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3))
                            ],
                          );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
