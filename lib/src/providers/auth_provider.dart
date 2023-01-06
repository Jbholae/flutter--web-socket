import 'dart:convert';

import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../injector.dart';
import '../models/user/user.dart';

class AuthProvider with ChangeNotifier {
  User? _dbUser;

  AuthProvider() : super() {
    final user = sharedPreferences.get("auth_user");
    if (user != null) {
      _dbUser = User.fromJson(jsonDecode(user as String));
      _loggedIn = true;
    }
  }

  void setAuthUser(User user) async {
    sharedPreferences.setString("auth_user", jsonEncode(user.toJson()));
    _dbUser = user;
    _loggedIn = true;
    notifyListeners();
  }

  User? get dbUser => _dbUser;

  bool _loggedIn = false;

  bool get loggedIn => _loggedIn;
}
