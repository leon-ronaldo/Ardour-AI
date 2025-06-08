import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';

// ignore: must_be_immutable
class SVGIcon extends FTContainer {
  SVGIcon(this.assetName, {super.key});

  final String assetRoot = "assets/icons";
  final String assetName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: boxShadow,
        borderRadius: borderRadius,
        border: border,
      ),
      child: SvgPicture.asset(
        '$assetRoot/$assetName.svg',
        height: height,
        width: width,
      ),
    );
  }
}
