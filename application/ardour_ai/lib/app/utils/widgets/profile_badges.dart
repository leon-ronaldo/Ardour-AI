import 'package:ardour_ai/app/utils/theme/colors.dart';
import 'package:ardour_ai/app/utils/theme/shadows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';
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
  });

  final String image;
  final String name;
  final int statusCount;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, isUser ? -0.5 : 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FTContainer(
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomRight,
                children: [
                  FTContainer()
                    ..boxShadow = AppShadows.baseShadow
                    ..height = height ?? 75
                    ..width = height ?? 75
                    ..bgImage = image
                    ..borderRadius = FTBorderRadii.roundedFull,

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
                                    ..borderRadius = FTBorderRadii.roundedFull
                                    ..bgColor = Color(0xffb45fb7),
                            )
                            ..borderRadius = FTBorderRadii.roundedFull
                            ..p = 0.7
                            ..bgColor = Colors.white,
                    ),
                ],
              ),
            )
            ..p = 2
            ..border = FTBorder.all(
              2.5,
              isUser ? Colors.white : AppColors.statusBorder,
            )
            ..borderRadius = FTBorderRadii.roundedFull
            ..mb = 5,

          Text(
            isUser ? "Your Story" : name,
            style: GoogleFonts.lato(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class ProfileNotesBadge extends StatelessWidget {
  const ProfileNotesBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            FTContainer()
              ..boxShadow = AppShadows.baseShadow
              ..height = height ?? 60
              ..width = height ?? 60
              ..mb = 5
              ..bgImage = image
              ..borderRadius = FTBorderRadii.roundedFull,

            Positioned(
              top: -10,
              child:
                  FTContainer(
                      child: Text(
                        note ?? name,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                          fontSize: 8,
                          color: Colors.white,
                        ),
                      ),
                    )
                    ..bgColor = const Color.fromARGB(255, 41, 41, 41)
                    ..borderRadius = FTBorderRadii.roundedLg
                    ..p = 5
                    ..width = 65,
            ),
          ],
        ),

        Text(name, style: GoogleFonts.lato(fontSize: 12)),
      ],
    );
  }
}
