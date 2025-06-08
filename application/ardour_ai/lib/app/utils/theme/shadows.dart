import 'package:flutter/widgets.dart';
import 'package:flutter_tailwind/utils/colors.dart';

class AppShadows {
  static final List<BoxShadow> baseShadow = [
    BoxShadow(blurRadius: 3, color: FTColors.gray300).scale(3),
  ];

  static final List<BoxShadow> downShadow = [
    BoxShadow(
      blurRadius: 3,
      color: FTColors.gray200,
      offset: Offset(0, 3),
    ).scale(3),
  ];
}
