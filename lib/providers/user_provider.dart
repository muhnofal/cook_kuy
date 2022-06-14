import 'package:cook_kuy/model/user.dart';
import 'package:cook_kuy/resources/auth_methods.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    try {
      User user = await _authMethods.getUserDetail();
      _user = user;
    } catch (e) {
      print("provider error ${e.toString()}");
    }

    notifyListeners();
  }
}
