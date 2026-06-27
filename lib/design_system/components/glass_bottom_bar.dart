import 'dart:ui';
import 'package:flutter/cupertino.dart';
import '../tokens/app_colors.dart';

/// SafeArea-aware frosted glass action bar pinned at the bottom of the screen.
/// Place inside a Stack as the last child so it overlays scrollable content.
class GlassBottomBar extends StatelessWidget {
  const GlassBottomBar({
    super.key,
    required this.child,
    this.blurSigma = 16.0,
    this.height = 56.0,
  });

  final Widget child;
  final double blurSigma;
  final double height;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.glassBackgroundThick.resolveFrom(context),
            border: Border(
              top: BorderSide(
                color: AppColors.glassBorder.resolveFrom(context),
                width: 0.5,
              ),
            ),
          ),
          child: SizedBox(
            height: height + bottomPadding,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
