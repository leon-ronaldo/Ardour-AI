import 'package:ardour_ai/app/utils/theme/colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
}
