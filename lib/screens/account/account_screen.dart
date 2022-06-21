import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/providers/user_provider.dart';
import 'package:cook_kuy/screens/account/widget/account_header.dart';
import 'package:cook_kuy/screens/account/widget/appbar_account.dart';
import 'package:cook_kuy/screens/account/widget/persistent_header.dart';
import 'package:cook_kuy/screens/router.dart';
import 'package:cook_kuy/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, index) {
          return [
            const AppbarAccount(),
            SliverToBoxAdapter(
              child: AccountHeader(uid: userProvider.getUser.uid),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: PersistentHeader(
                child: const TabBar(
                  unselectedLabelColor: Colors.grey,
                  labelColor: ijoSkripsi,
                  indicatorColor: ijoSkripsi,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.grid_on),
                    ),
                    Tab(
                      icon: Icon(Icons.favorite_rounded),
                    ),
                  ],
                ),
              ),
            )
          ];
        },
        body: TabBarView(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('recipe')
                    .where('uid', isEqualTo: userProvider.getUser.uid)
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
                                            image:
                                                NetworkImage(snap['image_url']),
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
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('recipe')
                    .where('favorite', arrayContains: userProvider.getUser.uid)
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
                                Icons.favorite,
                                size: 100,
                                color: Colors.grey[400],
                              ),
                              Text(
                                "No favorite menu",
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
                                      Navigator.of(context, rootNavigator: true)
                                          .pushNamed(AppRouter.recipeDetail,
                                              arguments: snap['recipe_id']);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                              NetworkImage(snap['image_url']),
                                        ),
                                      ),
                                    ),
                                  );
                                }, childCount: snapshot.data!.docs.length),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3))
                          ],
                        );
                })
          ],
        ),
      ),
    );
  }
}
