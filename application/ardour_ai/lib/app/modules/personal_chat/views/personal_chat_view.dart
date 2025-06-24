import 'package:ardour_ai/app/utils/theme/colors.dart';
import 'package:ardour_ai/app/utils/widgets/chat_widgets.dart';
import 'package:ardour_ai/app/utils/widgets/navbars.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/personal_chat_controller.dart';

class PersonalChatView extends GetView<PersonalChatController> {
  PersonalChatView({super.key});

  final TextStyle baseInfoStyle = GoogleFonts.poppins(
    fontSize: 14,
    color: Colors.white,
  );

  final TextStyle highLightedInfoStyle = GoogleFonts.poppins(
    fontSize: 14,
    color: Colors.yellowAccent.shade700,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.primaryBG,
      extendBody: true,
      body: Container(
        width: MainController.size.width,
        height: MainController.size.height,
        padding: EdgeInsets.only(top: MainController.padding.top + 15),
        alignment: Alignment.topCenter,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              children: [
                PersonalChatNavbar(
                  contact: controller.contact,
                  isTyping: controller.isTyping,
                  isOnline: controller.isOnline,
                ),
                Expanded(
                  child:
                      FTContainer(
                          child: Obx(
                            () => ListView.builder(
                              key: controller.chatSectionKey,
                              controller: controller.chatScrollController,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              itemCount: controller.chats.length + 2,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return FTContainer(
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Your messages with ",
                                              style: baseInfoStyle,
                                            ),
                                            TextSpan(
                                              text: controller.contact.userName,
                                              style: highLightedInfoStyle,
                                            ),
                                            TextSpan(
                                              text: " is ",
                                              style: baseInfoStyle,
                                            ),
                                            TextSpan(
                                              text: "end-to-end ",
                                              style: highLightedInfoStyle,
                                            ),
                                            TextSpan(
                                              text: "encrypted",
                                              style: baseInfoStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    ..width = MainController.size.width
                                    ..px = 40
                                    ..my = 20;
                                }

                                if (index == controller.chats.length + 1) {
                                  return SizedBox(height: 80);
                                }

                                final chat = controller.chats[index - 1];
                                final isSender =
                                    chat.from == controller.userId!;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child:
                                      isSender
                                          ? chat.isLiveMessage
                                              ? SenderChatAnimated(
                                                text: chat.message,
                                              )
                                              : SenderChat(text: chat.message)
                                          : chat.isLiveMessage
                                          ? RecieverChatAnimated(
                                            text: chat.message,
                                          )
                                          : RecieverChat(text: chat.message),
                                );
                              },
                            ),
                          ),
                        )
                        ..bgColor = AppColors.statusBorder
                        ..borderRadius
                        ..width = MainController.size.width,
                ),
              ],
            ),

            ChatTextField(
              textEditingController: controller.chatTextController,
              onSubmit: controller.sendText,
            ),
          ],
        ),
      ),
    );
  }
}
