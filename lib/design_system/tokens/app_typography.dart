import 'package:flutter/cupertino.dart';

abstract final class AppTypography {
  // SF Pro is resolved automatically on iOS via system font stack.
  // We apply slightly tighter tracking for headers and larger body fonts for 2026 feel.

  static const largeTitle = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.37,
    height: 1.21,
  );

  static const largeTitleBold = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.37,
    height: 1.21,
  );

  static const title1 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.36,
    height: 1.21,
  );

  static const title1Bold = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.36,
    height: 1.21,
  );

  static const title2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.35,
    height: 1.27,
  );

  static const title2Bold = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.35,
    height: 1.27,
  );

  static const title3 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.38,
    height: 1.30,
  );

  static const title3Semibold = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.38,
    height: 1.30,
  );

  static const headline = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.41,
    height: 1.29,
  );

  static const body = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.41,
    height: 1.29,
  );

  static const bodyMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.41,
    height: 1.29,
  );

  static const callout = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.32,
    height: 1.31,
  );

  static const calloutMedium = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.32,
    height: 1.31,
  );

  static const subheadline = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.24,
    height: 1.33,
  );

  static const subheadlineMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.24,
    height: 1.33,
  );

  static const footnote = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.08,
    height: 1.38,
  );

  static const footnoteMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.08,
    height: 1.38,
  );

  static const caption1 = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.33,
  );

  static const caption1Medium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
  );

  static const caption2 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.07,
    height: 1.36,
  );

  static const caption2Medium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.07,
    height: 1.36,
  );
}
