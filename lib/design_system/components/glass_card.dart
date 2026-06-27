import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import 'glass_surface.dart';

/// Rounded glass panel with consistent padding and optional tap feedback.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.sp16),
    this.borderRadius = AppRadius.radiusMD,
    this.onTap,
    this.blurSigma = 16.0,
  });

  final Widget child;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap == null
          ? null
          : () {
              HapticFeedback.selectionClick();
              onTap!();
            },
      child: GlassSurface(
        borderRadius: borderRadius,
        blurSigma: blurSigma,
        padding: padding,
        child: child,
      ),
    );
  }
}
