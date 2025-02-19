import 'package:ardour_ai/app/utils/functional_utils/isLoggedIn.dart';
import 'package:ardour_ai/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final initRoute = await isLoggedIn();

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: initRoute,
      theme: ThemeData(textTheme: GoogleFonts.openSansTextTheme()),
      getPages: AppPages.routes,
    ),
  );
}

class MainController extends GetxController {
  static Size screenSize = Size(0, 0);

  static const secureStorage = FlutterSecureStorage();

  static setScreenSize(BuildContext context) =>
      screenSize = MediaQuery.sizeOf(context);
}
