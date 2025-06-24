import 'dart:math' as Math;

import 'package:ardour_ai/app/modules/home/controllers/home_controller.dart';
import 'package:ardour_ai/app/modules/personal_chat/controllers/personal_chat_controller.dart';
import 'package:ardour_ai/app/routes/app_pages.dart';
import 'package:ardour_ai/app/utils/theme/colors.dart';
import 'package:ardour_ai/app/utils/widgets/drawables.dart';
import 'package:ardour_ai/app/utils/widgets/profile_badges.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.name,
    this.caption = "Messages are end-to-end encrypted",
    this.unreadMessages,
    required this.image,
  });

  final String name;
  final String caption;
  final String image;
  final int? unreadMessages;

  @override
  Widget build(BuildContext context) {
    return FTContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ProfileBadge(image: image),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: GoogleFonts.poppins()),
                    SizedBox(
                      width: MainController.size.width * 0.45,
                      child: Text(
                        caption,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: FTColors.gray400,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            unreadMessages == null
                ? Text(
                  "09:03 AM",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: FTColors.gray400,
                  ),
                )
                : (FTContainer(
                    child: Text(
                      unreadMessages.toString(),
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  )
                  ..width = 20
                  ..height = 20
                  ..borderRadius = FTBorderRadii.roundedFull
                  ..bgColor = AppColors.statusBorder),
          ],
        ),
      )
      ..px = 15
      ..py = 10
      ..width = MainController.size.width;
  }
}

class ChatTextField extends StatelessWidget {
  const ChatTextField({
    super.key,
    required this.textEditingController,
    required this.onSubmit,
  });

  final TextEditingController textEditingController;
  final GestureTapCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child:
          FTContainer(
              child: Row(
                children: [
                  Expanded(
                    child:
                        FTContainer(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.mic_sharp,
                                  color: AppColors.statusBorder,
                                  size: 20,
                                ),
                                FTContainer()
                                  ..mx = 10
                                  ..mr = 15
                                  ..bgColor = AppColors.statusBorder
                                  ..width = 0.5
                                  ..height = 20,
                                Expanded(
                                  child: TextField(
                                    controller: textEditingController,
                                    style: GoogleFonts.poppins(fontSize: 14),
                                    cursorColor: Colors.black,
                                    cursorWidth: 1,
                                    cursorHeight: 16,
                                    decoration: InputDecoration(
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 14,
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                ),

                                SizedBox(width: 10),

                                Transform.rotate(
                                  angle: -(Math.pi / 4),
                                  child: Icon(
                                    Icons.attachment_outlined,
                                    color: AppColors.statusBorder,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          )
                          ..borderRadius = FTBorderRadii.roundedFull
                          ..bgColor = Colors.white
                          ..mr = 15
                          ..px = 15,
                  ),

                  InkResponse(
                    onTap: onSubmit,
                    child:
                        SVGIcon("send-2")
                          ..bgColor = Colors.white
                          ..p = 12
                          ..borderRadius = FTBorderRadii.roundedFull,
                  ),
                ],
              ),
            )
            ..width = MainController.size.width
            ..py = 10
            ..m = 10,
    );
  }
}

class SenderChat extends StatelessWidget {
  const SenderChat({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final borderRadius = Radius.circular(20);

    return FTContainer(
      child: FTContainer(
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.statusBorder,
          ),
        ),
      )
        ..bgColor = Colors.white
        ..borderRadius = BorderRadius.only(
          bottomLeft: borderRadius,
          bottomRight: borderRadius,
          topLeft: borderRadius,
        )
        ..py = 10
        ..px = 20
        ..constraints = BoxConstraints(
          maxWidth: MainController.size.width * 0.7,
        ),
    )
      ..alignment = Alignment.centerRight
      ..width = MainController.size.width
      ..py = 5
      ..px = 10;
  }
}

class SenderChatAnimated extends StatefulWidget {
  const SenderChatAnimated({super.key, required this.text});

  final String text;

  @override
  State<SenderChatAnimated> createState() => _SenderChatAnimatedState();
}

class _SenderChatAnimatedState extends State<SenderChatAnimated> with TickerProviderStateMixin {
  final borderRadius = Radius.circular(20);

  late AnimationController _controller;
  late Animation<double> scale;
  late Animation<double> position;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this, duration: Durations.medium4);

    final animationParent = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    scale = Tween<double>(begin: 0.0, end: 1.0).animate(animationParent);

    position = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 15, end: 0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0, end: -15), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -15, end: 0), weight: 1),
    ]).animate(animationParent);

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FTContainer(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, oldWidget) {
            return Transform(
              transform:
                  Matrix4.identity()
                    ..translate(0.0, position.value)
                    ..scale(1.0, scale.value),
              child:
                  FTContainer(
                      child: Text(
                        widget.text,
                        style: GoogleFonts.poppins(
                          fontSize: 12 * scale.value,
                          color: AppColors.statusBorder,
                        ),
                      ),
                    )
                    ..bgColor = Colors.white
                    ..borderRadius = BorderRadius.only(
                      bottomLeft: borderRadius,
                      bottomRight: borderRadius,
                      topLeft: borderRadius,
                    )
                    ..py = 10
                    ..px = 20
                    ..constraints = BoxConstraints(
                      maxWidth: MainController.size.width * 0.7,
                    ),
            );
          },
        ),
      )
      ..alignment = Alignment.centerRight
      ..width = MainController.size.width
      ..py = 5
      ..px = 10;
  }
}

class RecieverChat extends StatelessWidget {
  const RecieverChat({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final borderRadius = Radius.circular(20);

    return FTContainer(
      child: FTContainer(
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      )
        ..bgColor = const Color(0xff766aec)
        ..borderRadius = BorderRadius.only(
          bottomLeft: borderRadius,
          bottomRight: borderRadius,
          topRight: borderRadius,
        )
        ..py = 10
        ..px = 20
        ..constraints = BoxConstraints(
          maxWidth: MainController.size.width * 0.7,
        ),
    )
      ..alignment = Alignment.centerLeft
      ..width = MainController.size.width
      ..py = 5
      ..px = 10;
  }
}

class RecieverChatAnimated extends StatefulWidget {
  const RecieverChatAnimated({super.key, required this.text});

  final String text;

  @override
  State<RecieverChatAnimated> createState() => _RecieverChatAnimatedState();
}

class _RecieverChatAnimatedState extends State<RecieverChatAnimated>
    with TickerProviderStateMixin {
  final borderRadius = Radius.circular(20);

  late AnimationController _controller;
  late Animation<double> scale;
  late Animation<double> position;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this, duration: Durations.medium4);

    final animationParent = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    scale = Tween<double>(begin: 0.0, end: 1.0).animate(animationParent);

    position = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 15, end: 0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0, end: -15), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -15, end: 0), weight: 1),
    ]).animate(animationParent);

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant RecieverChatAnimated oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FTContainer(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, oldWidget) {
            return Transform(
              transform:
                  Matrix4.identity()
                    ..translate(0.0, position.value)
                    ..scale(1.0, scale.value),
              child:
                  FTContainer(
                      child: Text(
                        widget.text,
                        style: GoogleFonts.poppins(
                          fontSize: 12 * scale.value,
                          color: Colors.white,
                        ),
                      ),
                    )
                    ..bgColor = Color(0xff766aec)
                    ..borderRadius = BorderRadius.only(
                      bottomLeft: borderRadius,
                      bottomRight: borderRadius,
                      topRight: borderRadius,
                    )
                    ..py = 10
                    ..px = 20
                    ..constraints = BoxConstraints(
                      maxWidth: MainController.size.width * 0.7,
                    ),
            );
          },
        ),
      )
      ..alignment = Alignment.centerLeft
      ..width = MainController.size.width
      ..py = 5
      ..px = 10;
  }
}
