import 'package:shared_preferences/shared_preferences.dart';

import 'config/api/api.dart';

late SharedPreferences sharedPreferences;

Future<void> initializeDependencies() async {
  // await Firebase.initializeApp();

  // init dio
  InitDio()();

  sharedPreferences = await SharedPreferences.getInstance();
}
