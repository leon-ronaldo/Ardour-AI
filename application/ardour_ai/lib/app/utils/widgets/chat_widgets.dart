import 'dart:math' as Math;

import 'package:ardour_ai/app/data/models.dart';
import 'package:ardour_ai/app/data/storage_service.dart';
import 'package:ardour_ai/app/utils/theme/colors.dart';
import 'package:ardour_ai/app/utils/tools/timeFunctions.dart';
import 'package:ardour_ai/app/utils/widgets/drawables.dart';
import 'package:ardour_ai/app/utils/widgets/profile_badges.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.name,
    this.caption = "Messages are end-to-end encrypted",
    this.unreadMessages,
    required this.image,
    this.timeStamp,
  });

  final String name;
  final String caption;
  final String image;
  final int? unreadMessages;
  final int? timeStamp;

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
                ? timeStamp != null
                    ? Text(
                      formatSmartTimestamp(timeStamp!),
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: FTColors.gray400,
                      ),
                    )
                    : Container()
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

class ReplyPreviewCard extends StatelessWidget {
  final ChatMessage? repliedTo;
  final Rx<ChatMessage?>? repliedToRx;
  final double bottomPadding;
  final double overallPadding;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color barColor;
  final Color textColor;

  const ReplyPreviewCard({
    super.key,
    this.repliedTo,
    this.repliedToRx,
    this.bottomPadding = 55,
    this.overallPadding = 5,
    this.backgroundColor = Colors.white,
    this.foregroundColor = const Color(0xFFE5E7EB),
    this.barColor = const Color(0xFF574CD6),
    this.textColor = Colors.black,
  }) : assert(
         repliedTo != null || repliedToRx != null,
         'Either repliedTo or repliedToRx must be provided.',
       );

  @override
  Widget build(BuildContext context) {
    if (repliedToRx != null) {
      return Obx(() {
        final reply = repliedToRx!.value;
        if (reply == null) return const SizedBox.shrink();
        return _buildCard(reply, true);
      });
    } else {
      if (repliedTo == null) return const SizedBox.shrink();
      return _buildCard(repliedTo!, false);
    }
  }

  Widget _buildCard(ChatMessage reply, bool isReactive) {
    return FTContainer(
        child: SizedBox(
          width: MainController.size.width,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 5,
                      decoration: BoxDecoration(
                        color: barColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                    ),

                    Expanded(
                      child:
                          FTContainer(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reply.senderName,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: barColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    reply.message,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 4,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            ..pl = 10
                            ..py = 8
                            ..pr = 20
                            ..alignment = Alignment.centerLeft
                            ..boxDecoration = BoxDecoration(
                              color: foregroundColor,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                    ),
                  ],
                ),
              ),

              if (isReactive)
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkResponse(
                    onTap: () => repliedToRx?.value = null,
                    child:
                        FTContainer(
                            child: const Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.white,
                            ),
                          )
                          ..p = 2
                          ..bgColor = Colors.black54
                          ..borderRadius = FTBorderRadii.roundedFull,
                  ),
                ),
            ],
          ),
        ),
      )
      ..p = overallPadding
      ..pb = bottomPadding
      ..pt = overallPadding + 2
      ..pl = overallPadding + 1
      ..bgColor = backgroundColor
      ..borderRadius = const BorderRadius.only(
        bottomLeft: Radius.circular(25),
        bottomRight: Radius.circular(25),
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      );
  }
}

class ChatTextField extends StatelessWidget {
  const ChatTextField({
    super.key,
    required this.textEditingController,
    required this.onSubmit,
    required this.repliedTo,
  });

  final TextEditingController textEditingController;
  final GestureTapCallback onSubmit;
  final Rx<ChatMessage?> repliedTo;
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child:
          FTContainer(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Obx(() {
                    final reply = repliedTo.value;
                    if (reply == null) return const SizedBox.shrink();

                    return ReplyPreviewCard(repliedToRx: repliedTo);
                  }),

                  IntrinsicHeight(
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
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextField(
                                          controller: textEditingController,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                          cursorColor: Colors.black,
                                          cursorWidth: 1,
                                          cursorHeight: 16,
                                          decoration: InputDecoration(
                                            hintText: "Type a message",
                                            hintStyle: GoogleFonts.poppins(
                                              fontSize: 14,
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                ..borderRadius = FTBorderRadii.rounded3xl
                                ..bgColor = Colors.white
                                ..mr = 15
                                ..px = 15,
                        ),

                        InkResponse(
                          onTap: onSubmit,
                          child:
                              FTContainer(
                                  child: Obx(
                                    () =>
                                        SVGIcon(
                                            repliedTo.value != null
                                                ? "send-2-white"
                                                : "send-2",
                                          )
                                          ..bgColor =
                                              repliedTo.value != null
                                                  ? AppColors.statusBorder
                                                  : Colors.white
                                          ..p = 8
                                          ..borderRadius =
                                              FTBorderRadii.roundedFull,
                                  ),
                                )
                                ..p = 4
                                ..bgColor = Colors.white
                                ..borderRadius = FTBorderRadii.roundedFull,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
            ..width = MainController.size.width
            ..py = 8
            ..m = 10,
    );
  }
}

class SenderChat extends StatelessWidget {
  const SenderChat({super.key, required this.message, required this.repliedTo});

  final ChatMessage message;
  final Rx<ChatMessage?> repliedTo;

  @override
  Widget build(BuildContext context) {
    final borderRadius = Radius.circular(20);

    return InkResponse(
      onDoubleTap: () {
        repliedTo.value = message..senderName = "You";
      },
      child:
          FTContainer(
              child:
                  FTContainer(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child:
                                FTContainer(
                                    child: Text(
                                      message.message,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: AppColors.statusBorder,
                                      ),
                                    ),
                                  )
                                  ..mr = 10
                                  ..mb = 3,
                          ),

                          Text(
                            message.formattedTime,
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              color: AppColors.statusBorder,
                            ),
                          ),
                        ],
                      ),
                    )
                    ..bgColor = Colors.white
                    ..borderRadius = BorderRadius.only(
                      bottomLeft: borderRadius,
                      bottomRight: borderRadius,
                      topLeft: borderRadius,
                    )
                    ..py = 5
                    ..px = 15
                    ..constraints = BoxConstraints(
                      maxWidth: MainController.size.width * 0.7,
                    ),
            )
            ..alignment = Alignment.centerRight
            ..width = MainController.size.width
            ..py = 2
            ..px = 10,
    );
  }
}

class SenderChatAnimated extends StatefulWidget {
  const SenderChatAnimated({
    super.key,
    required this.message,
    required this.repliedTo,
  });

  final ChatMessage message;
  final Rx<ChatMessage?> repliedTo;

  @override
  State<SenderChatAnimated> createState() => _SenderChatAnimatedState();
}

class _SenderChatAnimatedState extends State<SenderChatAnimated>
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
  Widget build(BuildContext context) {
    return InkResponse(
      onDoubleTap: () {
        widget.repliedTo.value = widget.message..senderName = "You";
      },
      child:
          FTContainer(
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child:
                                      FTContainer(
                                          child: Text(
                                            widget.message.message,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12 * scale.value,
                                              color: AppColors.statusBorder,
                                            ),
                                          ),
                                        )
                                        ..mr = 10
                                        ..mb = 3,
                                ),

                                Text(
                                  widget.message.formattedTime,
                                  style: GoogleFonts.poppins(
                                    fontSize: 9 * scale.value,
                                    color: AppColors.statusBorder,
                                  ),
                                ),
                              ],
                            ),
                          )
                          ..bgColor = Colors.white
                          ..borderRadius = BorderRadius.only(
                            bottomLeft: borderRadius,
                            bottomRight: borderRadius,
                            topLeft: borderRadius,
                          )
                          ..py = 5
                          ..px = 15
                          ..constraints = BoxConstraints(
                            maxWidth: MainController.size.width * 0.7,
                          ),
                  );
                },
              ),
            )
            ..alignment = Alignment.centerRight
            ..width = MainController.size.width
            ..py = 2
            ..px = 10,
    );
  }
}

class SenderRepliedChat extends StatelessWidget {
  const SenderRepliedChat({
    super.key,
    required this.message,
    required this.repliedTo,
    required this.repliedMessage,
  });

  final ChatMessage message;
  final ChatMessage repliedMessage;
  final Rx<ChatMessage?> repliedTo;

  @override
  Widget build(BuildContext context) {
    final borderRadius = Radius.circular(15);

    return InkResponse(
      onDoubleTap: () {
        repliedTo.value = message..senderName = "You";
      },
      child:
          FTContainer(
              child:
                  FTContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReplyPreviewCard(
                            repliedTo: repliedMessage,
                            bottomPadding: 5,
                            overallPadding: 3,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 8,
                              bottom: 5,
                              right: 8,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child:
                                      FTContainer(
                                          child: Text(
                                            message.message,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: AppColors.statusBorder,
                                            ),
                                          ),
                                        )
                                        ..alignment = Alignment.centerLeft
                                        ..mr = 10
                                        ..mb = 3,
                                ),

                                Container(
                                  margin: const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    message.formattedTime,
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      color: AppColors.statusBorder,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    ..bgColor = Colors.white
                    ..borderRadius = BorderRadius.only(
                      bottomLeft: borderRadius,
                      bottomRight: borderRadius,
                      topLeft: borderRadius,
                    )
                    ..pt = 1
                    ..constraints = BoxConstraints(
                      maxWidth: MainController.size.width * 0.7,
                    ),
            )
            ..alignment = Alignment.centerRight
            ..width = MainController.size.width
            ..py = 2
            ..px = 10,
    );
  }
}

class RecieverChat extends StatelessWidget {
  const RecieverChat({
    super.key,
    required this.message,
    required this.repliedToMessage,
  });

  final ChatMessage message;
  final Rx<ChatMessage?> repliedToMessage;

  @override
  Widget build(BuildContext context) {
    final borderRadius = Radius.circular(20);

    return InkResponse(
      onDoubleTap: () {
        String? sender =
            MainController.storageService.contacts
                .firstWhereOrNull((contact) => contact.userId == message.from)
                ?.userName;

        repliedToMessage.value = message..senderName = sender ?? "";
      },
      child:
          FTContainer(
              child:
                  FTContainer(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child:
                                FTContainer(
                                    child: Text(
                                      message.message,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                  ..mr = 10
                                  ..mb = 3,
                          ),

                          Text(
                            message.formattedTime,
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                    ..bgColor = const Color(0xff766aec)
                    ..borderRadius = BorderRadius.only(
                      bottomLeft: borderRadius,
                      bottomRight: borderRadius,
                      topRight: borderRadius,
                    )
                    ..py = 5
                    ..px = 15
                    ..constraints = BoxConstraints(
                      maxWidth: MainController.size.width * 0.7,
                    ),
            )
            ..alignment = Alignment.centerLeft
            ..width = MainController.size.width
            ..py = 2
            ..px = 10,
    );
  }
}

class RecieverChatAnimated extends StatefulWidget {
  const RecieverChatAnimated({
    super.key,
    required this.message,
    required this.repliedToMessage,
  });

  final ChatMessage message;
  final Rx<ChatMessage?> repliedToMessage;

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
  }

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onDoubleTap: () {
        String? sender =
            MainController.storageService.contacts
                .firstWhereOrNull(
                  (contact) => contact.userId == widget.message.from,
                )
                ?.userName;

        widget.repliedToMessage.value =
            widget.message..senderName = sender ?? "";
      },
      child:
          FTContainer(
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child:
                                      FTContainer(
                                          child: Text(
                                            widget.message.message,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12 * scale.value,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                        ..mr = 10
                                        ..mb = 3,
                                ),

                                Text(
                                  widget.message.formattedTime,
                                  style: GoogleFonts.poppins(
                                    fontSize: 9 * scale.value,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                          ..bgColor = Color(0xff766aec)
                          ..borderRadius = BorderRadius.only(
                            bottomLeft: borderRadius,
                            bottomRight: borderRadius,
                            topRight: borderRadius,
                          )
                          ..py = 5
                          ..px = 15
                          ..constraints = BoxConstraints(
                            maxWidth: MainController.size.width * 0.7,
                          ),
                  );
                },
              ),
            )
            ..alignment = Alignment.centerLeft
            ..width = MainController.size.width
            ..py = 2
            ..px = 10,
    );
  }
}

class RecieverRepliedChat extends StatelessWidget {
  const RecieverRepliedChat({
    super.key,
    required this.message,
    required this.repliedToMessage,
    required this.repliedMessage,
  });

  final ChatMessage message;
  final ChatMessage repliedMessage;
  final Rx<ChatMessage?> repliedToMessage;

  @override
  Widget build(BuildContext context) {
    final borderRadius = Radius.circular(15);

    return InkResponse(
      onDoubleTap: () {
        String? sender =
            MainController.storageService.contacts
                .firstWhereOrNull((contact) => contact.userId == message.from)
                ?.userName;

        repliedToMessage.value = message..senderName = sender ?? "";
      },
      child:
          FTContainer(
              child:
                  FTContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReplyPreviewCard(
                            repliedTo: repliedMessage,
                            bottomPadding: 5,
                            overallPadding: 3,
                            barColor: Color.fromARGB(255, 217, 231, 22),
                            textColor: Colors.white,
                            backgroundColor: const Color(0xff766aec),
                            foregroundColor: const Color.fromARGB(
                              255,
                              74,
                              68,
                              128,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 8,
                              bottom: 5,
                              right: 8,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child:
                                      FTContainer(
                                          child: Text(
                                            message.message,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                        ..alignment = Alignment.centerLeft
                                        ..mr = 10
                                        ..mb = 3,
                                ),

                                Container(
                                  margin: const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    message.formattedTime,
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    ..bgColor = const Color(0xff766aec)
                    ..borderRadius = BorderRadius.only(
                      bottomLeft: borderRadius,
                      bottomRight: borderRadius,
                      topRight: borderRadius,
                    )
                    ..pt = 1
                    ..constraints = BoxConstraints(
                      maxWidth: MainController.size.width * 0.7,
                    ),
            )
            ..alignment = Alignment.centerLeft
            ..width = MainController.size.width
            ..py = 2
            ..px = 10,
    );
  }
}
