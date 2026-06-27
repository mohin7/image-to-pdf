import 'package:flutter/cupertino.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';

class FlatCard extends StatelessWidget {
  const FlatCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.borderRadius,
    this.showBorder = true,
    this.showShadow = true,
    this.backgroundColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final bool showBorder;
  final bool showShadow;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppRadius.radiusMD;
    final bgColor = backgroundColor ?? AppColors.surfaceCard.resolveFrom(context);

    Widget card = DecoratedBox(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: radius,
        border: showBorder
            ? Border.all(
                color: AppColors.cardBorder.resolveFrom(context),
                width: 0.5,
              )
            : null,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: CupertinoColors.black.withValues(alpha: 0.05),
                  blurRadius: 24,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Padding(padding: padding, child: child),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: card,
      );
    }
    return card;
  }
}
