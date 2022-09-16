import 'package:cook_kuy/screens/account/account_screen.dart';
import 'package:cook_kuy/screens/accountlain/accountlain_screen.dart';
import 'package:cook_kuy/screens/admin/admin_comment_report.dart';
import 'package:cook_kuy/screens/admin/approval_admin.dart';
import 'package:cook_kuy/screens/createRecipe/create_recipe_screen.dart';
import 'package:cook_kuy/screens/cookScreen/cook_screen.dart';
import 'package:cook_kuy/screens/home/home_screen.dart';
import 'package:cook_kuy/screens/notification/notification_screen.dart';
import 'package:cook_kuy/screens/router.dart';
import 'package:cook_kuy/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class AdminNavigationScreen extends StatefulWidget {
  const AdminNavigationScreen({Key? key}) : super(key: key);

  @override
  State<AdminNavigationScreen> createState() => _AdminNavigationScreenState();
}

class _AdminNavigationScreenState extends State<AdminNavigationScreen> {
  PersistentTabController? _controller;

  List<Widget> _buildScreen() {
    return [
      const ApprovalAdmin(),
      const AdminCommentReport(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItem() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_outlined),
        title: ('Approval'),
        textStyle: const TextStyle(fontSize: 10),
        activeColorPrimary: ijoSkripsi,
        inactiveColorPrimary: kuningSkripsi,
        routeAndNavigatorSettings: const RouteAndNavigatorSettings(
          initialRoute: AppRouter.home,
          onGenerateRoute: AppRouter.generateRoute,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.comment),
        title: ('Comment Report'),
        textStyle: const TextStyle(fontSize: 10),
        activeColorPrimary: ijoSkripsi,
        inactiveColorPrimary: kuningSkripsi,
        routeAndNavigatorSettings: const RouteAndNavigatorSettings(
          initialRoute: AppRouter.searchRecipeAdmin,
          onGenerateRoute: AppRouter.generateRoute,
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: _buildScreen(),
      controller: _controller,
      items: _navBarsItem(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      popActionScreens: PopActionScreensType.all,
      bottomScreenMargin: 50,
      decoration: const NavBarDecoration(
        border: Border(top: BorderSide(width: 1, color: Colors.grey)),
      ),
      popAllScreensOnTapOfSelectedTab: true,
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.simple,
    );
  }
}
