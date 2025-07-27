import 'dart:math' as math;

import 'package:ardour_ai/app/data/models.dart';
import 'package:ardour_ai/app/modules/chats/controllers/chats_controller.dart';
import 'package:ardour_ai/app/modules/home/controllers/home_controller.dart';
import 'package:ardour_ai/app/routes/app_pages.dart';
import 'package:ardour_ai/app/utils/theme/colors.dart';
import 'package:ardour_ai/app/utils/widgets/drawables.dart';
import 'package:ardour_ai/app/utils/widgets/search_bars.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';
import 'package:get/get.dart';
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
                  child: Obx(
                    () => Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topRight,
                      children: [
                        if (controller.haveNotifications.value)
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

class ChatPageNavbar extends StatefulWidget {
  const ChatPageNavbar({super.key});

  @override
  State<ChatPageNavbar> createState() => _ChatPageNavbarState();
}

class _ChatPageNavbarState extends State<ChatPageNavbar> {
  RxString userName = "".obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MainController.user.then((u) => userName.value = u?.userName ?? "");
  }

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
                    child: SVGIcon("arrow-back")..width = 16,
                  ),
                )..mt = 3,

                SizedBox(width: 10),

                Obx(
                  () => Text(
                    userName.value,
                    style: GoogleFonts.outfit(fontSize: 22),
                  ),
                ),
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
                    child: SVGIcon("arrow-back")..height = 16,
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

class PersonalChatNavbar extends StatelessWidget {
  const PersonalChatNavbar({
    super.key,
    required this.contact,
    required this.isTyping,
    required this.isOnline,
  });

  final PassUser contact;
  final RxBool isTyping;
  final RxBool isOnline;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MainController.size.width,
      color: AppColors.statusBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FTContainer(
              child: Row(
                children: [
                  InkResponse(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),

                  FTContainer()
                    ..width = 45
                    ..height = 45
                    ..mx = 15
                    ..borderRadius = FTBorderRadii.roundedFull
                    ..bgImage =
                        contact.profileImage ?? "assets/images/sample/raul.jpg",

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            contact.userName,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        Obx(
                          () =>
                              isOnline.value == true
                                  ? Text(
                                    isTyping.value == true
                                        ? "Typing..."
                                        : "Online",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 9,
                                    ),
                                  )
                                  : Container(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
            ..px = 20
            ..py = 15,

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomPaint(size: Size(25, 25), painter: ChatNavPainter()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(35),
                      ),
                      color: AppColors.primaryBG,
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
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
                  ),
                  CustomPaint(size: Size(30, 25), painter: ChatNavPainter()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatNavPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = AppColors.primaryBG;

    final path = Path();

    // start
    path.moveTo(0, 0);

    path.lineTo(size.width, 0);

    path.lineTo(size.width, size.height);

    path.quadraticBezierTo(size.width * 0.8, size.height * 0.1, 0, 0);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
