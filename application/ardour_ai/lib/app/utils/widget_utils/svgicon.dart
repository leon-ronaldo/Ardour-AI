import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Svgicon extends StatelessWidget {
  const Svgicon(
      {super.key, required this.icon, this.height = 20, this.width = 20});

  final String basePath = "assets/icons";
  final String icon;

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "$basePath/$icon.svg",
      height: height,
      width: height,
    );
  }
}
