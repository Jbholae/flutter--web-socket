import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../injector.dart';
import '../../models/rooms/chat_room_model.dart';
import '../../pages/chat_detail_page.dart';
import '../../pages/home_page.dart';
import '../../pages/login_user.dart';
import '../../pages/register_user.dart';
import '../../providers/auth_provider.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoutes(RouteSettings settings) {
    final authContext =
        Provider.of<AuthProvider>(mainNavigator.currentContext!, listen: false);
    if (!authContext.loggedIn) {
      switch (settings.name) {
        case RegisterUser.routeName:
          return _materialRoute(const RegisterUser());
        case LoginUser.routeName:
          return _materialRoute(const LoginUser());
      }
    }

    if (authContext.loggedIn) {
      switch (settings.name) {
        case "/":
          return _materialRoute(HomePage());
        case "/chat":
          return _materialRoute(
            ChatDetailPage(room: settings.arguments as ChatRoom),
          );
      }
    }

    switch (settings.name) {
      default:
        throw const FormatException('Route not found');
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(
      builder: (_) => GestureDetector(
        onTap: () => dismissKeyboard(),
        child: view,
      ),
    );
  }
}
