import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../resources/assets_manager.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final double size;

  const CustomLoadingIndicator({
    super.key,
    this.size = 80.0,
  });

  @pragma('vm:entry-point')
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        ImageAssets.smallLogoKoki,
        width: size,
        height: size,
        fit: BoxFit.contain,
      )
          .animate(
        onPlay: (controller) => controller.repeat(reverse: true),
      )
          .scaleXY(
        begin: 0.85,
        end: 1.15,
        duration: 800.ms,
        curve: Curves.easeInOut,
      )
          .fade(
        begin: 0.7,
        end: 1.0,
        duration: 800.ms,
        curve: Curves.easeInOut,
      ),
    );
  }
}