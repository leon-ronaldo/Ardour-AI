import 'package:ardour_ai/app/utils/theme/colors.dart';
import 'package:ardour_ai/app/utils/widgets/drawables.dart';
import 'package:ardour_ai/app/utils/widgets/error_display.dart';
import 'package:ardour_ai/app/utils/widgets/navbars.dart';
import 'package:ardour_ai/app/utils/widgets/profile_badges.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/notifications_page_controller.dart';

class NotificationsPageView extends GetView<NotificationsPageController> {
  const NotificationsPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBG,
      body:
          FTContainer(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    NotificationsNavbar(),
                    SizedBox(height: 10),
                    Obx(
                      () => Visibility(
                        visible: controller.isReady.value,
                        replacement: PlaceHolderLoader(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (controller.accountRequestNotifications.isEmpty)
                              ErrorDisplay(
                                title: "No notifications yet",
                                subTitle:
                                    "Your notifications will appear here once you have recieved it.",
                                helperText: "Missing Notifications?",
                                actionLabel: "Get notification history",
                                svgAsset: "postbox",
                              ),

                            // notifications
                            FTContainer(
                                child: Column(
                                  children: [
                                    ...controller.accountRequestNotifications
                                        .map(
                                          (requestNotification) =>
                                              ProfileNotificationBadge(
                                                onAccept:
                                                    () => controller
                                                        .acceptAccountRequest(
                                                          requestNotification
                                                              .userId,
                                                        ),
                                                notification:
                                                    requestNotification,
                                              ),
                                        ),
                                  ],
                                ),
                              )
                              ..mt = 10
                              ..ml = 10,
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 30),
                  ],
                ),
              ),
            )
            ..pt = MainController.padding.top + 10
            ..height = MainController.size.height
            ..width = MainController.size.width
            ..alignment = Alignment.topCenter,
    );
  }
}
