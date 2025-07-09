import 'package:ardour_ai/app/data/models.dart';
import 'package:ardour_ai/app/utils/theme/colors.dart';
import 'package:ardour_ai/app/utils/tools/timeFunctions.dart';
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
    fontSize: 12,
    color: Colors.white,
  );

  final TextStyle highLightedInfoStyle = GoogleFonts.poppins(
    fontSize: 12,
    color: Colors.yellowAccent.shade700,
  );

  Widget buildChatBubble(ChatMessage chat, bool isSender) {
    final repliedTo = controller.repliedToMessage;

    if (isSender) {
      if (chat.isLiveMessage) {
        return SenderChatAnimated(message: chat, repliedTo: repliedTo);
      } else if (chat.repliedTo != null) {
        print("naa adhu vanthiruku ${chat.toJson()}");
        final repliedMessage = controller.chats.firstWhereOrNull(
          (message) =>
              (message.id ?? "no id dude") == (chat.repliedTo ?? "no bro!"),
        );

        if (repliedMessage != null) {
          repliedMessage.senderName =
              repliedMessage.from == controller.contact.userId
                  ? controller.contact.userName
                  : "You";
          return SenderRepliedChat(
            message: chat,
            repliedTo: repliedTo,
            repliedMessage: repliedMessage,
          );
        } else {
          print("naa adhu vanthiruku aprm kanom ${chat.toJson()}");
          return SenderChat(message: chat, repliedTo: repliedTo);
        }
      } else {
        return SenderChat(message: chat, repliedTo: repliedTo);
      }
    } else {
      if (chat.isLiveMessage) {
        return RecieverChatAnimated(message: chat, repliedToMessage: repliedTo);
      } else if (chat.repliedTo != null) {
        print("naa adhu vanthiruku ${chat.toJson()}");
        final repliedMessage = controller.chats.firstWhereOrNull(
          (message) =>
              (message.id ?? "no id dude") == (chat.repliedTo ?? "no bro!"),
        );

        if (repliedMessage != null) {
          repliedMessage.senderName =
              repliedMessage.from == controller.contact.userId
                  ? controller.contact.userName
                  : "You";
          return RecieverRepliedChat(
            message: chat,
            repliedToMessage: repliedTo,
            repliedMessage: repliedMessage,
          );
        } else {
          print("naa adhu vanthiruku aprm kanom ${chat.toJson()}");
          return SenderChat(message: chat, repliedTo: repliedTo);
        }
      } else {
        return RecieverChat(message: chat, repliedToMessage: repliedTo);
      }
    }
  }

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
                              padding: EdgeInsets.only(
                                top: 10,
                                bottom: controller.chatFieldHeight.value,
                              ),
                              itemCount: controller.chats.length + 1,
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

                                final framedIndex = index - 1;
                                final chat = controller.chats[framedIndex];
                                final isSender =
                                    chat.from == controller.userId!;

                                if (framedIndex == 0) {
                                  return Column(
                                    children: [
                                      FTContainer(
                                          child: Text(
                                            formatSmartTimestamp(
                                              chat.timestamp,
                                              today: "Today",
                                            ),
                                            style: GoogleFonts.poppins(
                                              fontSize: 9,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                        ..mb = 50
                                        ..mt = 20
                                        ..px = 15
                                        ..py = 5
                                        ..borderRadius = FTBorderRadii.roundedLg
                                        ..bgColor = Color(0xff1d1f1f),

                                      buildChatBubble(chat, isSender),
                                    ],
                                  );
                                } else {
                                  final previousChat =
                                      controller.chats[framedIndex - 1];

                                  if (!isSameDate(
                                    previousChat.timestamp,
                                    chat.timestamp,
                                  )) {
                                    return Column(
                                      children: [
                                        FTContainer(
                                            child: Text(
                                              formatSmartTimestamp(
                                                chat.timestamp,
                                                today: "Today",
                                              ),
                                              style: GoogleFonts.poppins(
                                                fontSize: 9,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                          ..my = 50
                                          ..px = 15
                                          ..py = 5
                                          ..borderRadius =
                                              FTBorderRadii.roundedLg
                                          ..bgColor = Color(0xff1d1f1f),

                                        buildChatBubble(chat, isSender),
                                      ],
                                    );
                                  } else {
                                    return previousChat.from != chat.from
                                        ? Column(
                                          children: [
                                            SizedBox(height: 15),
                                            buildChatBubble(chat, isSender),
                                          ],
                                        )
                                        : buildChatBubble(chat, isSender);
                                  }
                                }
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
              key: controller.chatFieldKey,
              textEditingController: controller.chatTextController,
              onSubmit: controller.sendText,
              repliedTo: controller.repliedToMessage,
            ),
          ],
        ),
      ),
    );
  }
}
