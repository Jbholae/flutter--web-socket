import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart' show ChangeNotifier, ModalRoute;

import '../app.dart';
import '../config/firebase/auth.dart';
import '../injector.dart';
import '../models/user/user.dart';
import '../pages/login_user.dart';

class AuthProvider with ChangeNotifier {
  User? _dbUser;

  AuthProvider() {
    addListener(() {
      if (mainNavigator.currentContext != null) {
        if (loggedIn &&
            ModalRoute.of(mainNavigator.currentContext!)?.settings.name !=
                "/") {
          mainNavigator.currentState?.pushReplacementNamed("/");
          return;
        }

        if (ModalRoute.of(mainNavigator.currentContext!)?.settings.name !=
            LoginUser.routeName) {
          mainNavigator.currentState?.pushReplacementNamed(LoginUser.routeName);
        }
      }
    });

    firebaseAuth.authStateChanges().listen((auth.User? user) {
      if (user != null) {
        _user = user;
        _loggedIn = true;
        _dbUser = User.fromJson({
          "id": user.uid,
          "full_name": user.displayName,
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

  User? get dbUser => _dbUser;

  bool _loggedIn = false;

  bool get loggedIn => _loggedIn;

  auth.User? _user;

  auth.User? get user => _user;
}
