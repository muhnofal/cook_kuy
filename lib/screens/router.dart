import 'package:cook_kuy/screens/account/account_screen.dart';
import 'package:cook_kuy/screens/account/editprofile_screen.dart';
import 'package:cook_kuy/screens/account/followingandfollowers_screen.dart';
import 'package:cook_kuy/screens/accountlain/accountlain_screen.dart';
import 'package:cook_kuy/screens/cookScreen/additional_ingre_screen.dart';
import 'package:cook_kuy/screens/createRecipe/create_recipe_screen.dart';
import 'package:cook_kuy/screens/cookScreen/cook_screen.dart';
import 'package:cook_kuy/screens/home/home_screen.dart';
import 'package:cook_kuy/screens/home/search_user_screen.dart';
import 'package:cook_kuy/screens/login/login_screen.dart';
import 'package:cook_kuy/screens/notification/notification_screen.dart';
import 'package:cook_kuy/screens/recipeDetail/navigate_recipe_detail_screen.dart';
import 'package:cook_kuy/screens/recipeDetail/recipe_detail_screen.dart';
import 'package:cook_kuy/screens/register/register_screen.dart';
import 'package:cook_kuy/screens/searchResult/search_result.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const home = '/';
  static const searchUsers = '/search_users';
  static const login = 'login';
  static const register = 'register';
  static const createRecipe = '/create_recipe';
  static const cook = '/cook';
  static const account = '/account';
  static const followingandfollowers = '/followingandfollowers';
  static const additionalIngre = '/additional_ingre';
  static const searchResult = 'additional_ingre/search_result';
  static const recipeDetail = '/recipe_detail';
  static const recipeDetailTemp = '/recipe_detail_temp';
  static const navrecipeDetail = '/nav_recipe_detail';
  static const anotherAccount = '/another_account';
  static const editProfile = '/edit_profile';
  static const notification = '/notification';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case searchUsers:
        return MaterialPageRoute(builder: (_) => const SearchUsers());
      case account:
        return MaterialPageRoute(builder: (_) => const AccountScreen());
      case followingandfollowers:
        return MaterialPageRoute(
            builder: (_) => const FollowingAndFollowersScreen());
      case cook:
        return MaterialPageRoute(builder: (_) => const CookScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case createRecipe:
        return MaterialPageRoute(builder: (_) => const CreateRecipeScreen());
      case notification:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case navrecipeDetail:
        return MaterialPageRoute(builder: (_) => const NavRecipeDetail());
      case additionalIngre:
        var args = routeSettings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => AdditionalIngreScreen(
                  mainIngre: args,
                ));
      case searchResult:
        var args = routeSettings.arguments as CompleteIngre;
        return MaterialPageRoute(
            builder: (_) => SearchResultScreen(completeIngre: args));
      case recipeDetail:
        var args = routeSettings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => RecipeDetailScreen(
                  recipeId: args,
                ));
      case anotherAccount:
        var args = routeSettings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => AccountLain(
                  anotherUserId: args,
                ));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                body: Center(
                    child: Text("No Route found for ${routeSettings.name}"))));
    }
  }
}
