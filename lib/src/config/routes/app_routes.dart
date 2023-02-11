import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app.dart';
import '../../injector.dart';
import '../../models/rooms/chat_room_model.dart';
import '../../pages/chat_page.dart';
import '../../pages/home_page.dart';
import '../../pages/login_page.dart';
import '../../pages/register_page.dart';
import '../../providers/auth_provider.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoutes(RouteSettings settings) {
    final authContext =
        Provider.of<AuthProvider>(mainNavigator.currentContext!, listen: false);
    if (!authContext.loggedIn) {
      switch (settings.name) {
        case RegisterPage.routeName:
          return _materialRoute(const RegisterPage());
        case LoginPage.routeName:
          return _materialRoute(const LoginPage());
      }
    }

    if (authContext.loggedIn) {
      switch (settings.name) {
        case HomePage.routeName:
          return _materialRoute(const HomePage());
        case ChatPage.routeName:
          return _materialRoute(
            ChatPage(room: settings.arguments as ChatRoom),
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
