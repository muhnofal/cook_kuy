import 'package:cook_kuy/screens/account/widget/account_header.dart';
import 'package:cook_kuy/screens/account/widget/appbar_account.dart';
import 'package:cook_kuy/screens/account/widget/persistent_header.dart';
import 'package:cook_kuy/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, index) {
          return [
            const AppbarAccount(),
            const SliverToBoxAdapter(
              child: AccountHeader(),
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
            CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverGrid(
                  
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://picsum.photos/id/${index + 1068}/500/500'),
                          ),
                        ),
                      );
                    }, childCount: 17),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3))
              ],
            ),
            CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://picsum.photos/id/${index + 1068}/500/500'),
                          ),
                        ),
                      );
                    }, childCount: 17),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3))
              ],
            )
          ],
        ),
      ),
    );
  }
}
