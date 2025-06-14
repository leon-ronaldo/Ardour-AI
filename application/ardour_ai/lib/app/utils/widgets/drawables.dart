import 'package:ardour_ai/app/utils/theme/colors.dart';
import 'package:ardour_ai/main.dart';
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

class PlaceHolderLoader extends StatelessWidget {
  const PlaceHolderLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return FTContainer(
        child: Center(
          child: CircularProgressIndicator(color: AppColors.statusBorder),
        ),
      )
      ..mt = 50
      ..width = MainController.size.width;
  }
}
