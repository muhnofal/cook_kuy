import 'package:cook_kuy/screens/account/account_screen.dart';
import 'package:cook_kuy/screens/accountlain/accountlain_screen.dart';
import 'package:cook_kuy/screens/createRecipe/create_recipe_screen.dart';
import 'package:cook_kuy/screens/cookScreen/cook_screen.dart';
import 'package:cook_kuy/screens/home/home_screen.dart';
import 'package:cook_kuy/screens/notification/notification_screen.dart';
import 'package:cook_kuy/screens/router.dart';
import 'package:cook_kuy/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class NewNavigationScreen extends StatefulWidget {
  const NewNavigationScreen({Key? key}) : super(key: key);

  @override
  State<NewNavigationScreen> createState() => _NewNavigationScreenState();
}

class _NewNavigationScreenState extends State<NewNavigationScreen> {
  PersistentTabController? _controller;

  List<Widget> _buildScreen() {
    return [
      const HomeScreen(),
      const CookScreen(),
      const CreateRecipeScreen(),
      const NotificationScreen(),
      const AccountScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItem() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_outlined),
        title: ('Home'),
        textStyle: const TextStyle(fontSize: 10),
        activeColorPrimary: ijoSkripsi,
        inactiveColorPrimary: kuningSkripsi,
        routeAndNavigatorSettings: const RouteAndNavigatorSettings(
          initialRoute: AppRouter.home,
          onGenerateRoute: AppRouter.generateRoute,
        ),
        //ini masih ada yang harus ditambahkan
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.soup_kitchen_outlined),
        title: ('Cook'),
        textStyle: const TextStyle(fontSize: 10),
        activeColorPrimary: ijoSkripsi,
        inactiveColorPrimary: kuningSkripsi,
        routeAndNavigatorSettings: const RouteAndNavigatorSettings(
          initialRoute: AppRouter.cook,
          onGenerateRoute: AppRouter.generateRoute,
        ),
        //ini masih ada yang harus ditambahkan
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.receipt_long_outlined),
        title: ('Create Recipe'),
        textStyle: const TextStyle(fontSize: 10),
        activeColorPrimary: ijoSkripsi,
        inactiveColorPrimary: kuningSkripsi,
        routeAndNavigatorSettings: const RouteAndNavigatorSettings(
          initialRoute: AppRouter.createRecipe,
          onGenerateRoute: AppRouter.generateRoute,
        ),
        //ini masih ada yang harus ditambahkan
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.notifications_none_outlined),
        title: ('Notification'),
        textStyle: const TextStyle(fontSize: 10),
        activeColorPrimary: ijoSkripsi,
        inactiveColorPrimary: kuningSkripsi,
        routeAndNavigatorSettings: const RouteAndNavigatorSettings(
          initialRoute: AppRouter.notification,
          onGenerateRoute: AppRouter.generateRoute,
        ),
        //ini masih ada yang harus ditambahkan
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person_outline_rounded),
        title: ('Account'),
        textStyle: const TextStyle(fontSize: 10),
        activeColorPrimary: ijoSkripsi,
        inactiveColorPrimary: kuningSkripsi,
        routeAndNavigatorSettings: const RouteAndNavigatorSettings(
          initialRoute: AppRouter.account,
          onGenerateRoute: AppRouter.generateRoute,
        ),
        //ini masih ada yang harus ditambahkan
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
