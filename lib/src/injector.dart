import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

Future<void> initializeDependencies() async {
  // await Firebase.initializeApp();
  sharedPreferences = await SharedPreferences.getInstance();
}
