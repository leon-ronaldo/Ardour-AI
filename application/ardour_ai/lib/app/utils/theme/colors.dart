import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBG = Colors.white;
  static Color info = Colors.blueAccent.shade400;
  static Color danger = Colors.redAccent.shade400;
  static Color warning = Colors.amberAccent.shade400;
  static const Color success = Colors.green;
  static const Color statusBorder = Color(0xff574cd6);

  static const LinearGradient baseGradient = LinearGradient(
    colors: [
      Color(0xff574cd6), // Base Indigo
      Color(0xff3f51b5), // Deep Blue
      Color(0xffd64ca3), // Vivid Pink
      Color(0xffffb347), // Warm Gold
    ],
    stops: [0.0, 0.33, 0.66, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
