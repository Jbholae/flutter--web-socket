import 'package:flutter/material.dart';

import 'src/app.dart';
import 'config.dart';
import 'src/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDependencies();

  runApp(
    const App(),
  );
}
