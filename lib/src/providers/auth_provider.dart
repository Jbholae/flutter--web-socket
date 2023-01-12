import 'dart:convert';

import 'package:flutter/material.dart' show ChangeNotifier, ModalRoute;

import '../app.dart';
import '../config/firebase/auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../injector.dart';
import '../models/user/user.dart';

class AuthProvider with ChangeNotifier {
  User? _dbUser;

  AuthProvider() {
    // final user = sharedPreferences.get("auth_user");
    // if (user != null) {
    //   _dbUser = User.fromJson(jsonDecode(user as String));
    //   _loggedIn = true;
    // }

    addListener(() {
      if (mainNavigator.currentContext != null) {
        if (loggedIn &&
            ModalRoute.of(mainNavigator.currentContext!)?.settings.name !=
                "/") {
          mainNavigator.currentState?.pushReplacementNamed("/");
          return;
        }

        if (ModalRoute.of(mainNavigator.currentContext!)?.settings.name !=
            "login") {
          mainNavigator.currentState?.pushReplacementNamed("login");
        }
      }
    });

    firebaseAuth.authStateChanges().listen((auth.User? user) {
      if (user != null) {
        _user = user;
        _loggedIn = true;
        _dbUser = User.fromJson({
          "id": user.uid,
          "name": user.displayName,
          "email": user.email,
        });
      } else {
        _loggedIn = false;
        _user = null;
        _dbUser = null;
      }
      notifyListeners();
      sharedPreferences.setBool("loggedIn", _loggedIn);
    });
  }

  void setAuthUser(User user) async {
    // sharedPreferences.setString("auth_user", jsonEncode(user.toJson()));
    _dbUser = user;
    // _loggedIn = true;
    notifyListeners();
  }

  User? get dbUser => _dbUser;

  bool _loggedIn = false;

  bool get loggedIn => _loggedIn;

  auth.User? _user;
  auth.User? get user => _user;
}
