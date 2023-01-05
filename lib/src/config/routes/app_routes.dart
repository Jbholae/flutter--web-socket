import 'package:flutter/material.dart';
import 'package:flutter_skeleton/src/app.dart';
import 'package:flutter_skeleton/src/pages/home_page.dart';
import 'package:flutter_skeleton/src/pages/profile.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoutes(RouteSettings settings) {
    final authContext =
        Provider.of<AuthProvider>(mainNavigator.currentContext!, listen: false);
    if (!authContext.loggedIn) {
      switch (settings.name) {
        case 'user':
          return _materialRoute(const ProfileScreen());
      }
    }

    if (authContext.loggedIn) {
      switch (settings.name) {
        case '/':
          return _materialRoute(const HomePage());
      }
    }

    switch (settings.name) {
      default:
        throw const FormatException('Route not found');
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
