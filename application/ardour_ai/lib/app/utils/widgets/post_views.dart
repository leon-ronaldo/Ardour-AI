import 'package:ardour_ai/app/utils/theme/shadows.dart';
import 'package:ardour_ai/app/utils/widgets/drawables.dart';
import 'package:ardour_ai/app/utils/widgets/profile_badges.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';
import 'package:google_fonts/google_fonts.dart';

class ImagePostView extends StatelessWidget {
  const ImagePostView({
    super.key,
    required this.name,
    required this.profileImage,
    required this.postImage,
    required this.caption,
  });

  final String profileImage;
  final String postImage;
  final String name;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return FTContainer(
        child: Column(
          children: [
            // profile info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileBadge(image: profileImage)..width = 40,
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: GoogleFonts.poppins(fontSize: 14)),
                          Text(
                            "Posted 3d ago",
                            style: GoogleFonts.poppins(fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),

                  InkResponse(child: Icon(Icons.more_horiz_rounded)),
                ],
              ),
            ),

            SizedBox(height: 10),

            // post image
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MainController.size.height * 0.8,
                minWidth: MainController.size.width,
              ),
              child: Image.asset(postImage, fit: BoxFit.fitWidth),
            ),

            SizedBox(height: 10),

            // caption
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(caption, style: GoogleFonts.lato(fontSize: 14)),
            ),

            SizedBox(height: 10),

            // like buttons
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SVGIcon("like-outlined"),
                      Text("4.3k", style: GoogleFonts.poppins(fontSize: 14)),
                      SizedBox(width: 20),
                      SVGIcon("comment"),
                      Text("1.2k", style: GoogleFonts.poppins(fontSize: 14)),
                    ],
                  ),
                  SVGIcon("bookmark")..width = 22,
                ],
              ),
            ),
          ],
        ),
      )
      ..bgColor = Colors.white
      ..mb = 15
      ..width = MainController.size.width
      ..py = 15
      ..borderRadius = FTBorderRadii.rounded2xl;
    // ..boxShadow = AppShadows.downShadow;
  }
}
