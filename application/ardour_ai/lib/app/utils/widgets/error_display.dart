import 'package:ardour_ai/app/utils/widgets/drawables.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorDisplay extends StatelessWidget {
  ErrorDisplay({
    super.key,
    required this.title,
    required this.subTitle,
    this.helperText,
    this.actionLabel,
    this.onActionClick,
    required this.svgAsset,
  });

  final String svgAsset;
  final String title;
  final String subTitle;

  String? helperText;
  String? actionLabel;
  final VoidCallback? onActionClick;

  @override
  Widget build(BuildContext context) {
    return FTContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SVGIcon(svgAsset)
              ..width = 100
              ..mb = 20,
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                height: 1,
                fontSize: 26,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            FTContainer(
                child: Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
              )
              ..px = 30
              ..my = 10,

            if (helperText != null)
              FTContainer(
                child: Text(
                  helperText!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 13, height: 1),
                ),
              )..mt = 10,

            if (actionLabel != null)
              InkResponse(
                onTap:
                    onActionClick ??
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Nigga why you still here?")),
                    ),
                child: Text(
                  actionLabel!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.blueAccent,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        ),
      )
      ..width = MainController.size.width
      ..height = MainController.size.height * 0.7;
  }
}
