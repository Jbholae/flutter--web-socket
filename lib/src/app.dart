import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'config/routes/app_routes.dart';
import 'config/themes/app_theme.dart';
import 'pages/register_user.dart';
import 'providers/auth_provider.dart';
import 'providers/message_notifier_provider.dart';

final mainNavigator = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MessageNotifierProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      builder: (context, child) {
        return Sizer(builder: (_, orientation, deviceType) {
          return MaterialApp(
            debugShowCheckedModeBanner: kDebugMode,
            navigatorKey: mainNavigator,
            title: ("Skeleton"),
            theme: AppTheme.light,
            initialRoute: context.watch<AuthProvider>().loggedIn
                ? "/"
                : RegisterUser.routeName,
            onGenerateRoute: (settings) {
              return AppRouter.onGenerateRoutes(
                settings,
              );
            },
          );
        });
      },
    );
  }
}
