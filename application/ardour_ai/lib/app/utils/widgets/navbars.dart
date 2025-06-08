import 'dart:math' as math;

import 'package:ardour_ai/app/routes/app_pages.dart';
import 'package:ardour_ai/app/utils/widgets/drawables.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class MainNavBar extends StatelessWidget {
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
                SVGIcon("bell")..width = 20,
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
                SVGIcon("send")
                  ..width = 20
                  ..ml = 20,
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
