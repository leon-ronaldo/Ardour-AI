import 'dart:async';
import 'dart:math';

import 'package:ardour_ai/app/utils/widgets/drawables.dart';
import 'package:ardour_ai/app/utils/widgets/profile_badges.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';
import 'package:get/get.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: FTBorderRadii.rounded2xl,
      ),
      margin: const EdgeInsets.only(bottom: 15),
      width: MainController.size.width,
      padding: const EdgeInsets.symmetric(vertical: 15),

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
    );
    // ..boxShadow = AppShadows.downShadow;
  }
}

class ImageSlideShowPostView extends StatefulWidget {
  const ImageSlideShowPostView({
    super.key,
    required this.name,
    required this.profileImage,
    required this.postImages,
    required this.caption,
  });

  final String profileImage;
  final List<String> postImages;
  final String name;
  final String caption;

  @override
  State<ImageSlideShowPostView> createState() => _ImageSlideShowPostViewState();
}

class _ImageSlideShowPostViewState extends State<ImageSlideShowPostView> {
  double maxImageHeight = 200; // default minimum
  final pageController = PageController();
  RxInt pageIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    _calculateMaxImageHeight();
    pageController.addListener(() {
      pageIndex.value = pageController.page?.round() ?? 0;
    });
  }

  void _calculateMaxImageHeight() async {
    double screenWidth = MainController.size.width;
    double screenHeight = MainController.size.height;

    double localMaxHeight = 0;

    for (String path in widget.postImages) {
      final Completer<Size> completer = Completer<Size>();

      final Image image =
          path.startsWith('http') ? Image.network(path) : Image.asset(path);

      image.image
          .resolve(const ImageConfiguration())
          .addListener(
            ImageStreamListener((ImageInfo info, bool _) {
              final mySize = Size(
                info.image.width.toDouble(),
                info.image.height.toDouble(),
              );

              // Scale image height based on fitWidth logic
              double aspectRatio = mySize.height / mySize.width;
              double scaledHeight = screenWidth * aspectRatio;

              completer.complete(Size(screenWidth, scaledHeight));
            }),
          );

      final Size size = await completer.future;
      localMaxHeight = max(localMaxHeight, size.height);
    }

    setState(() {
      maxImageHeight = localMaxHeight.clamp(0, screenHeight * 0.8);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: FTBorderRadii.rounded2xl,
      ),
      margin: const EdgeInsets.only(bottom: 15),
      width: MainController.size.width,
      padding: const EdgeInsets.symmetric(vertical: 15),

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
                    ProfileBadge(image: widget.profileImage)..width = 40,
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
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
          Container(
            constraints: BoxConstraints(
              minWidth: MainController.size.width,
              maxHeight: maxImageHeight,
            ),
            color: Colors.black,
            child: PageView.builder(
              controller: pageController,
              itemCount: widget.postImages.length,
              itemBuilder: (context, index) {
                final path = widget.postImages[index];
                final isUrl = path.startsWith('http');
                return isUrl
                    ? Image.network(path, fit: BoxFit.cover)
                    : Image.asset(path, fit: BoxFit.cover);
              },
            ),
          ),

          FTContainer(
            child: Row(
              children: List.generate(
                widget.postImages.length,
                (index) => FTContainer(
                  child: Obx(
                    () => Icon(
                      pageIndex.value == index
                          ? Icons.circle
                          : Icons.circle_outlined,
                      size: 6,
                      color: Colors.black,
                    ),
                  ),
                )..mx = 2,
              ),
            ),
          )..my = 10,

          // caption
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(widget.caption, style: GoogleFonts.lato(fontSize: 14)),
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
    );
    // ..boxShadow = AppShadows.downShadow;
  }
}
