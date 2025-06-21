import 'package:ardour_ai/app/utils/theme/colors.dart';
import 'package:ardour_ai/app/utils/widgets/profile_badges.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';
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
