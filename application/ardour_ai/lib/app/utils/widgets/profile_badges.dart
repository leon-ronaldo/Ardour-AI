// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:ardour_ai/app/data/models.dart';
import 'package:ardour_ai/app/data/websocket_models.dart';
import 'package:ardour_ai/app/utils/theme/colors.dart';
import 'package:ardour_ai/app/utils/theme/shadows.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileBadge extends FTContainer {
  ProfileBadge({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return FTContainer()
      ..boxShadow = AppShadows.baseShadow
      ..height = height ?? width ?? 55
      ..width = height ?? width ?? 55
      ..mb = 5
      ..bgImage = image
      ..borderRadius = FTBorderRadii.roundedFull;
  }
}

class ProfileBadgeWithName extends FTContainer {
  ProfileBadgeWithName({super.key, required this.name, required this.image});

  final String image;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FTContainer()
          ..boxShadow = AppShadows.baseShadow
          ..height = height ?? 60
          ..width = height ?? 60
          ..mb = 5
          ..bgImage = image
          ..borderRadius = FTBorderRadii.roundedFull,

        Text(name, style: GoogleFonts.lato(fontSize: 12)),
      ],
    );
  }
}

class ProfileStatusBadge extends FTContainer {
  ProfileStatusBadge({
    required this.statusCount,
    super.key,
    this.name = "Your Story",
    required this.image,
    this.isUser = false,
  }) {
    if (isUser) {
      isLoading.value = true;
      _loadImage();
    } else {
      loadedImage.value = image;
    }
  }

  final String image;
  final String name;
  final int statusCount;
  final bool isUser;

  final RxBool isLoading = false.obs;
  final RxString loadedImage = "".obs;

  void _loadImage() async {
    final img = await MainController.profileImage;
    loadedImage.value = img ?? "assets/images/sample/raul.jpg";
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, isUser ? -0.5 : 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FTContainer(
              child:
                  FTContainer(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomRight,
                        children: [
                          Obx(() {
                            return FTContainer()
                              ..boxShadow = AppShadows.baseShadow
                              ..height = height ?? 75
                              ..width = height ?? 75
                              ..bgImage = loadedImage.value
                              ..borderRadius = FTBorderRadii.roundedFull;
                          }),
                          if (isUser)
                            Positioned(
                              bottom: -2.5,
                              child:
                                  FTContainer(
                                      child:
                                          FTContainer(
                                              child: Icon(
                                                Icons.add,
                                                size: 12,
                                                color: Colors.white,
                                              ),
                                            )
                                            ..p = 2
                                            ..borderRadius =
                                                FTBorderRadii.roundedFull
                                            ..bgColor = const Color(0xffb45fb7),
                                    )
                                    ..borderRadius = FTBorderRadii.roundedFull
                                    ..p = 0.7
                                    ..bgColor = Colors.white,
                            ),
                        ],
                      ),
                    )
                    ..p = 1.5
                    ..borderRadius = FTBorderRadii.roundedFull
                    ..bgColor = Colors.white,
            )
            ..p = 2
            ..mb = 5
            ..boxDecoration = BoxDecoration(
              borderRadius: FTBorderRadii.roundedFull,
              color: isUser ? Colors.white : null,
              gradient: !isUser ? AppColors.baseGradient : null,
            ),
          Text(
            isUser ? "Your Story" : name,
            style: GoogleFonts.lato(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class ProfileStat extends StatelessWidget {
  final String title;
  final String count;

  const ProfileStat({super.key, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
        const SizedBox(height: 4),
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class ProfileBadgeWithNotes extends FTContainer {
  ProfileBadgeWithNotes({
    super.key,
    required this.name,
    required this.image,
    this.note,
    this.isUser = false,
  });

  final String image;
  final String name;
  final String? note;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              left: 15,
              child:
                  FTContainer()
                    ..width = 8
                    ..height = 8
                    ..borderRadius = FTBorderRadii.roundedFull
                    ..bgColor = const Color.fromARGB(255, 41, 41, 41),
            ),

            Positioned(
              left: 22,
              bottom: -5,
              child:
                  FTContainer()
                    ..width = 5
                    ..height = 5
                    ..borderRadius = FTBorderRadii.roundedFull
                    ..bgColor = const Color.fromARGB(255, 41, 41, 41),
            ),
            FTContainer(
                child: Text(
                  note ?? "Your Note",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(fontSize: 9, color: Colors.white),
                ),
              )
              ..bgColor = const Color.fromARGB(255, 41, 41, 41)
              ..borderRadius = FTBorderRadii.roundedXl
              ..p = 5
              ..py = 7
              ..width = 65
              ..mb = 5,
          ],
        ),
        FTContainer(
          child: Column(
            children: [
              FTContainer()
                ..boxShadow = AppShadows.baseShadow
                ..height = height ?? 60
                ..width = height ?? 60
                ..mb = 5
                ..bgImage = image
                ..borderRadius = FTBorderRadii.roundedFull,

              SizedBox(
                width: 65,
                child: Text(
                  name,
                  style: GoogleFonts.lato(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        )..ml = 10,
      ],
    );
  }
}

class ProfileFollowRequestCard extends StatefulWidget {
  const ProfileFollowRequestCard({
    super.key,
    required this.name,
    required this.image,
    required this.userId,
    this.handle,
    this.followers = "897",
    this.following = "640",
  });

  final String name;
  final String image;
  final String? handle;
  final String userId;
  final String following;
  final String followers;

  @override
  State<ProfileFollowRequestCard> createState() =>
      _ProfileFollowRequestCardState();
}

class _ProfileFollowRequestCardState extends State<ProfileFollowRequestCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _nameOpacity;
  late Animation<double> _handleOpacity;
  late Animation<double> _statsOpacity;
  late Animation<double> _buttonOpacity;

  late Animation<double> _namePosition;
  late Animation<double> _handlePosition;
  late Animation<double> _statsPosition;
  late Animation<double> _buttonPosition;

  Timer? returnTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _nameOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );
    _handleOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
      ),
    );
    _statsOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );
    _buttonOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _namePosition = Tween(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );
    _handlePosition = Tween(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
      ),
    );
    _statsPosition = Tween(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );
    _buttonPosition = Tween(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget animatedItem({
    required Animation<double> opacity,
    required Animation<double> position,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder:
          (context, _) => Opacity(
            opacity: opacity.value,
            child: Transform.translate(
              offset: Offset(0, position.value),
              child: child,
            ),
          ),
    );
  }

  animate() {
    if (_controller.isAnimating || returnTimer != null) {
      return;
    }
    _controller.forward();
    returnTimer = Timer(const Duration(seconds: 5), () {
      _controller.reverse();
      returnTimer = null;
    });
  }

  void makeFriendRequest() {
    try {
      MainController.service.send(
        WSBaseRequest(
          type: WSModuleType.Account,
          reqType: AccountReqType.MAKE_REQUEST,
          data: {'userId': widget.userId},
        ),
      );
    } catch (e) {
      print("make request la error bro $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: animate,
      child: Stack(
        children: [
          // Background image
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 160),
              child: Builder(
                builder: (_) {
                  if (widget.image.startsWith('data:image/')) {
                    final base64Str = widget.image.split(',').last;
                    final bytes = base64Decode(base64Str);
                    return Image.memory(bytes, fit: BoxFit.cover);
                  } else if (widget.image.startsWith('http')) {
                    return Image.network(widget.image, fit: BoxFit.cover);
                  } else {
                    return Image.asset(widget.image, fit: BoxFit.cover);
                  }
                },
              ),
            ),
          ),

          // Glassmorphism Layer
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder:
                  (context, _) => Opacity(
                    opacity: _nameOpacity.value, // Can be adjusted or separated
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0.5),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            ),
          ),

          // Foreground content
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                animatedItem(
                  opacity: _nameOpacity,
                  position: _namePosition,
                  child: Text(
                    widget.name,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 4),
                if (widget.handle != null)
                  animatedItem(
                    opacity: _handleOpacity,
                    position: _handlePosition,
                    child: Text(
                      widget.handle!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                animatedItem(
                  opacity: _statsOpacity,
                  position: _statsPosition,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ProfileStat(title: "Following", count: widget.following),
                      ProfileStat(title: "Followers", count: widget.followers),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                animatedItem(
                  opacity: _buttonOpacity,
                  position: _buttonPosition,
                  child: InkResponse(
                    onTap: makeFriendRequest,
                    child:
                        FTContainer(
                            child: Text(
                              "Follow",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          )
                          ..p = 10
                          ..m = 1
                          ..width = MainController.size.width
                          ..bgColor = AppColors.statusBorder,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileNotificationBadge extends StatelessWidget {
  const ProfileNotificationBadge({
    super.key,
    required this.notification,
    this.onAccept,
  });

  final dynamic notification;
  final Function? onAccept;

  bool get isAccountReqNotification => notification is AccountReqNotification;
  bool get isPostNotification => notification is PostNotification;

  @override
  Widget build(BuildContext context) {
    return FTContainer(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileBadge(
              image:
                  notification.profileImage ?? "assets/images/sample/raul.jpg",
            ),

            SizedBox(width: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MainController.size.width * 0.65,
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: notification.userName,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text:
                              isAccountReqNotification
                                  ? " sent a friend request"
                                  : isPostNotification
                                  ? " has posted recently"
                                  : " has new update",
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5),

                Text(
                  notification.timeAgo,
                  style: GoogleFonts.poppins(fontSize: 11),
                ),

                SizedBox(height: 5),

                if (isAccountReqNotification)
                  Row(
                    children: [
                      InkResponse(
                        onTap: () => onAccept?.call(),
                        child:
                            FTContainer(
                                child:
                                    FTContainer(
                                        child: Text(
                                          "Accept",
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                          ),
                                        ),
                                      )
                                      ..px = 10
                                      ..py = 5
                                      ..width = 80
                                      ..bgColor = Colors.white
                                      ..borderRadius = BorderRadius.circular(6),
                              )
                              ..p = 1.5
                              ..boxDecoration = BoxDecoration(
                                gradient: AppColors.baseGradient,
                                borderRadius: BorderRadius.circular(8),
                              )
                              ..mr = 10,
                      ),

                      FTContainer(
                          child: Text(
                            "Deny",
                            style: GoogleFonts.poppins(fontSize: 10),
                          ),
                        )
                        ..px = 10
                        ..width = 80
                        ..py = 6
                        ..bgColor = Colors.white
                        ..border = FTBorder.all(1.5, AppColors.danger)
                        ..borderRadius = BorderRadius.circular(8),
                    ],
                  ),
              ],
            ),
          ],
        ),
      )
      ..p = 10
      ..width = MainController.size.width;
  }
}
