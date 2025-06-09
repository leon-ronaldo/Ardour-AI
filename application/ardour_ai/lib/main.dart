import 'package:ardour_ai/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

class MainController {
  // size
  static Size screenSize = Size(0, 0);
  static Size get size => screenSize;
  static set size(context) => screenSize = MediaQuery.sizeOf(context);

  // padding
  static EdgeInsets screenPadding = EdgeInsets.zero;
  static EdgeInsets get padding => screenPadding;
  static set padding(context) => screenPadding = MediaQuery.paddingOf(context);

  // utils
  static final storage = FlutterSecureStorage();
  static Future<String?> get accessToken async => await storage.read(key: "accessToken");
  static Future<String?> get refreshToken async => await storage.read(key: "refreshToken");
}
