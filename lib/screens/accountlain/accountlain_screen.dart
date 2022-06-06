import 'package:cook_kuy/screens/account/widget/persistent_header.dart';
import 'package:cook_kuy/screens/accountlain/widget/accountlain_header.dart';
import 'package:cook_kuy/screens/accountlain/widget/appbar_accountlain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../utils/colors.dart';

class AccountLain extends StatefulWidget {
  const AccountLain({Key? key}) : super(key: key);

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
            const SliverToBoxAdapter(
              child: AccountHeaderLain(),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: PersistentHeader(
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child:  Text(
                    "Resep User",
                    style:  TextStyle(fontWeight: FontWeight.bold),
                  ),
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
          ],
        ),
      ),
    );
  }
}