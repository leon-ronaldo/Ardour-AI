import 'package:ardour_ai/app/utils/widget_utils/glass_container.dart';
import 'package:ardour_ai/app/utils/widget_utils/svgicon.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';
import 'package:flutter_tailwind/widets/tw_container.dart';

import 'package:get/get.dart';

import '../controllers/chat_page_controller.dart';

const List<Color> chatBubbleColors = [
  Color(0xff3a3044),
  Color(0xff6d959e),
  Color(0xffd9d5e9),
  Color(0xffeddbdb),
  Color(0xffd8edc2),
];

class ChatPageView extends GetView<ChatPageController> {
  const ChatPageView({super.key});
  @override
  Widget build(BuildContext context) {
    MainController.setScreenSize(context);
    return Scaffold(
      backgroundColor: Color(0xfff1f1f3),
      extendBodyBehindAppBar: true,
      appBar: GlassMorphismAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                FTContainer()
                  ..height = 45
                  ..width = 45
                  ..bgImage = "assets/images/profile.jpeg"
                  ..borderRadius = FTBorderRadii.roundedLg
                  ..border = FTBorder.all(1.5, Colors.white),
                FTContainer(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Micheal",
                        style: TextStyle(fontSize: 16, height: 1),
                      ),
                      Text(
                        "Online",
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      )
                    ],
                  ),
                )
                  ..px = 10
                  ..alignment = Alignment.centerLeft
                  ..width = MainController.screenSize.width * 0.4,
              ],
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Svgicon(icon: "fav"),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Svgicon(icon: "menu"),
                ),
              ],
            ),
          ],
        ),
      ),
      body: FTColumn(
        children: [
          Expanded(
            child: Obx(
              () => SingleChildScrollView(
                reverse: true,
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.paddingOf(context).top + 60, bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(controller.chats.length, (index) {
                      controller.bgColorCounter.value =
                          (controller.bgColorCounter.value + 1) %
                              chatBubbleColors.length;

                      return Align(
                        alignment: Alignment.centerRight,
                        child: FTContainer(
                          child: Text(
                            controller.chats.elementAt(index),
                            style: TextStyle(
                              color: chatBubbleColors[controller
                                              .bgColorCounter.value] ==
                                          Color(0xff3a3044) ||
                                      chatBubbleColors[controller
                                              .bgColorCounter.value] ==
                                          Color(0xff6d959e)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        )
                          ..borderRadius = FTBorderRadii.roundedXl
                          ..p = 10
                          ..my = 8
                          ..constraints = BoxConstraints(
                              maxWidth: MainController.screenSize.width * 0.6)
                          ..bgColor =
                              chatBubbleColors[controller.bgColorCounter.value],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
          ChatBox(),
        ],
      )
        ..p = 15
        ..height = MainController.screenSize.height
        ..width = MainController.screenSize.width
        ..mainAxisAlignment = MainAxisAlignment.spaceBetween,
    );
  }
}

class GlassMorphismAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Widget child;
  final double height;

  const GlassMorphismAppBar({
    super.key,
    required this.child,
    this.height = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    return GlassMorphismContainer(
      width: double.infinity,
      height: height + MediaQuery.paddingOf(context).top,
      borderRadius: 15.0,
      color: Colors.white24, // The color for the background
      blurStrength: 10.0, // Adjust the blur effect
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top, left: 15, right: 15),
        child: child,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class ChatBox extends GetWidget<ChatPageController> {
  const ChatBox({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    return FTContainer(
      child: Row(
        children: [
          FTContainer(child: Svgicon(icon: "link"))..mr = 5,
          Expanded(
              child: FTContainer(
            child: TextField(
              controller: textController,
              onSubmitted: (text) {
                if (text != "") {
                  controller.addChat(text);
                  // controller.chatScrollController.jumpTo(
                  //     controller.chatScrollController.position.maxScrollExtent);
                  textController.clear();
                }
              },
              decoration: const InputDecoration(
                hintText: "Type a message...",
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero, // No extra padding
              ),
            ),
          )..p = 0),
          Row(
            children: [
              FTContainer(
                child: Svgicon(icon: "send"),
              )..p = 5,
              FTContainer(
                child: Svgicon(icon: "mic-on"),
              )..p = 5
            ],
          )
        ],
      ),
    )
      ..width = MainController.screenSize.width
      ..px = 15
      ..bgColor = Colors.white
      ..borderRadius = FTBorderRadii.roundedFull;
  }
}
