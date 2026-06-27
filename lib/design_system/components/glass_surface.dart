import 'dart:ui';
import 'package:flutter/cupertino.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';

/// Frosted glass surface using BackdropFilter.
/// Place this in a Stack above the content to blur — BackdropFilter only
/// blurs siblings rendered beneath it in the same render layer.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.blurSigma = 20.0,
    this.borderRadius = AppRadius.radiusMD,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 0.5,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final double blurSigma;
  final BorderRadius borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.glassBackground.resolveFrom(context);
    final border = borderColor ?? AppColors.glassBorder.resolveFrom(context);

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: borderRadius,
            border: Border.all(color: border, width: borderWidth),
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
