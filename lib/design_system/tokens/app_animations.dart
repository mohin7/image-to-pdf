import 'package:flutter/animation.dart';

abstract final class AppAnimations {
  // Spring physics matching iOS system spring animations
  static const springSnappy = SpringDescription(
    mass: 1.0,
    stiffness: 400.0,
    damping: 30.0,
  );

  static const springDefault = SpringDescription(
    mass: 1.0,
    stiffness: 300.0,
    damping: 28.0,
  );

  static const springBouncy = SpringDescription(
    mass: 1.0,
    stiffness: 200.0,
    damping: 20.0,
  );

  // Standard durations
  static const durationInstant = Duration(milliseconds: 100);
  static const durationFast = Duration(milliseconds: 200);
  static const durationMedium = Duration(milliseconds: 350);
  static const durationSlow = Duration(milliseconds: 500);
  static const durationVerySlow = Duration(milliseconds: 700);

  // Curves
  static const curveDefault = Curves.easeInOut;
  static const curveEntrance = Curves.easeOut;
  static const curveExit = Curves.easeIn;
  static const curveBounce = Curves.elasticOut;
  static const curveSharp = Curves.easeInOutCubic;

  // flutter_animate shorthand durations (ms)
  static const int fastMs = 200;
  static const int mediumMs = 350;
  static const int slowMs = 500;
}
