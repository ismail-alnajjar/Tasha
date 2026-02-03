import 'dart:ui';
import 'package:flutter/material.dart';

class SplashBackgroundShape extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double width;
  final double height;
  final Color? color;
  final Gradient? gradient;
  final double blurAmount;
  final double opacity;

  const SplashBackgroundShape({
    super.key,
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.width,
    required this.height,
    this.color,
    this.gradient,
    this.blurAmount = 0.0,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Opacity(
        opacity: opacity,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              gradient: gradient,
              boxShadow: color != null && blurAmount > 0
                  ? [
                      BoxShadow(
                        color: color!.withOpacity(0.6),
                        blurRadius: blurAmount,
                        spreadRadius: blurAmount / 2,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
