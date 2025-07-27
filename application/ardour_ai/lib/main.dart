import 'dart:convert';
import 'dart:ui';

import 'package:ardour_ai/app/data/models.dart';
import 'package:ardour_ai/app/data/storage_service.dart';
import 'package:ardour_ai/app/data/websocket_service.dart';
import 'package:ardour_ai/firebase_notifications.dart';
import 'package:ardour_ai/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  LocalNotificationService.initialize();
  NotificationService().initNotifications();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };

  // await FlutterSecureStorage().deleteAll();

  PlatformDispatcher.instance.onError = (error, stack) {
    print("Caught unhandled error: $error");
    return true;
  };
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme()
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(MainController());
      }),
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
  static final storageService = StorageServices();

  static Future<String?> get accessToken async =>
      await storage.read(key: "accessToken");
  static Future<String?> get refreshToken async =>
      await storage.read(key: "refreshToken");

  static Future<PassUser?> get user async => PassUser.fromJSON(
    jsonDecode(await MainController.storage.read(key: "user") ?? "{}"),
  );

  // ws service
  static final WebSocketService service = WebSocketService();
}
