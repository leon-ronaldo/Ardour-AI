import 'dart:ui';
import 'package:flutter/material.dart';

class GlassMorphismContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final double blurStrength;
  final Color color;
  final Widget? child;

  const GlassMorphismContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 15.0,
    this.blurStrength = 10.0,
    this.color = Colors.white24,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurStrength, sigmaY: blurStrength),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
