import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';
import 'services/app_services.dart';

late SharedPreferences sharedPreferences;
late AppRepoImplementation apiService;

Future<void> initializeDependencies() async {
  await Firebase.initializeApp(
    options: !Platform.isAndroid
        ? FirebaseOptions(
            apiKey: Config.firebaseConfig["apiKey"]!,
            authDomain: Config.firebaseConfig["authDomain"],
            projectId: Config.firebaseConfig["projectId"]!,
            storageBucket: Config.firebaseConfig["storageBucket"],
            messagingSenderId: Config.firebaseConfig["messagingSenderId"]!,
            appId: Config.firebaseConfig["appId"]!,
          )
        : null,
  );
  sharedPreferences = await SharedPreferences.getInstance();
  apiService = AppRepoImplementation();
}

void dismissKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}
