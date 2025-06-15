import 'dart:math' as math;

import 'package:ardour_ai/app/modules/home/controllers/home_controller.dart';
import 'package:ardour_ai/app/routes/app_pages.dart';
import 'package:ardour_ai/app/utils/theme/colors.dart';
import 'package:ardour_ai/app/utils/widgets/drawables.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class MainNavBar extends GetWidget<HomeController> {
  const MainNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return FTContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Ardourgram",
              style: TextStyle(fontSize: 22, fontFamily: "InstaSans"),
            ),
            Row(
              children: [
                InkResponse(
                  onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topRight,
                    children: [
                      Positioned(
                        top: -5,
                        child: Icon(
                          Icons.circle,
                          color: AppColors.statusBorder,
                          size: 8,
                        ),
                      ),
                      SVGIcon("bell")..width = 20,
                    ],
                  ),
                ),
                InkResponse(
                  onTap: () => Get.toNamed(Routes.CHATS),
                  child:
                      SVGIcon("send")
                        ..width = 20
                        ..ml = 20,
                ),
              ],
            ),
          ],
        ),
      )
      ..width = MainController.size.width
      ..py = 20
      ..pl = 20
      ..pr = 20;
  }
}

class ChatPageNavbar extends StatelessWidget {
  const ChatPageNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return FTContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                FTContainer(
                  child: InkResponse(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back_ios_new, size: 16),
                  ),
                )..mt = 3,

                SizedBox(width: 10),

                Text("Leon Ronaldo", style: GoogleFonts.outfit(fontSize: 22)),
              ],
            ),

            Row(
              children: [
                SVGIcon("bell")..width = 20,
                InkResponse(
                  onTap: () => Get.toNamed(Routes.ADD_FRIENDS),
                  child:
                      SVGIcon("add-user")
                        ..width = 20
                        ..ml = 20,
                ),
              ],
            ),
          ],
        ),
      )
      ..width = MainController.size.width
      ..px = 15
      ..py = 10;
  }
}

class NotificationsNavbar extends StatelessWidget {
  const NotificationsNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return FTContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                FTContainer(
                  child: InkResponse(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back_ios_new, size: 16),
                  ),
                )..mt = 3,

                SizedBox(width: 10),

                Text("Notifications", style: GoogleFonts.outfit(fontSize: 22)),
              ],
            ),

            SVGIcon("settings")..width = 20,
          ],
        ),
      )
      ..width = MainController.size.width
      ..px = 15
      ..py = 10;
  }
}
