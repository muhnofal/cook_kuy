import 'package:cook_kuy/screens/account/account_screen.dart';
import 'package:cook_kuy/screens/accountlain/accountlain_screen.dart';
import 'package:cook_kuy/screens/cookScreen/additional_ingre_screen.dart';
import 'package:cook_kuy/screens/createRecipe/create_recipe_screen.dart';
import 'package:cook_kuy/screens/cookScreen/cook_screen.dart';
import 'package:cook_kuy/screens/home/home_screen.dart';
import 'package:cook_kuy/screens/login/login_screen.dart';
import 'package:cook_kuy/screens/recipeDetail/recipe_detail_screen.dart';
import 'package:cook_kuy/screens/register/register_screen.dart';
import 'package:cook_kuy/screens/searchResult/search_result.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const home = '/';
  static const login = 'login';
  static const register = 'register';
  static const createRecipe = '/create_recipe';
  static const cook = '/cook';
  static const account = '/account';
  static const accountLain = '/accountlain';
  static const searchResult = '/search_result';
  static const additionalIngre = '/search_result/additional_ingre';
  static const recipeDetail = '/search_result/recipe_detail';


  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case account:
        return MaterialPageRoute(builder: (_) => const AccountScreen());
      case accountLain:
        return MaterialPageRoute(builder: (_) => const AccountLain());
      case cook:
        return MaterialPageRoute(builder: (_) => const CookScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case createRecipe:
        return MaterialPageRoute(builder: (_) => const CreateRecipeScreen());
      case additionalIngre:
      var args = routeSettings.arguments as String;
        return MaterialPageRoute(builder: (_) => AdditionalIngreScreen(mainIngre: args,));
      case searchResult:
      var args = routeSettings.arguments as CompleteIngre;
        return MaterialPageRoute(builder: (_) => SearchResultScreen(completeIngre: args));
      case recipeDetail:
      var args = routeSettings.arguments as dynamic;
        return MaterialPageRoute(builder: (_) => RecipeDetailScreen(snap: args,));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                body: Center(
                    child: Text("No Route found for ${routeSettings.name}"))));
    }
  }
}
