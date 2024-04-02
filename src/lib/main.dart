import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'app_initializer.dart';
import 'app_widget.dart';

void main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final AppInitializer initializer = AppInitializer();
  await initializer.initialize();
  runApp(const AppWidget());
  FlutterNativeSplash.remove();
}
