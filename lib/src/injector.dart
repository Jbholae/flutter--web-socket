import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/app_services.dart';

late SharedPreferences sharedPreferences;
late AppRepoImplementation apiService;

Future<void> initializeDependencies() async {
  await Firebase.initializeApp();
  sharedPreferences = await SharedPreferences.getInstance();
  apiService = AppRepoImplementation();
}
