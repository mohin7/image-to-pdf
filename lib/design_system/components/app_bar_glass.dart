import 'dart:ui';

import 'package:flutter/cupertino.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// Professional frosted-glass navigation bar.
///
/// Features:
/// - Real BackdropFilter blur (20σ) — translucent, not opaque
/// - Optional [subtitle] shown beneath the title in a muted style
/// - Optional [leadingAccent] mode — draws a small accent bar on the left
///   of the title area, used on main/root screens for brand identity
/// - Optional [leading] / [trailing] action widgets with correct padding
/// - Optional thin accent line at the very top edge (off by default)
class AppBarGlass extends StatelessWidget implements PreferredSizeWidget {
  const AppBarGlass({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.blurSigma = 20.0,
    this.showBorder = true,
    this.showAccentLine = false,
  });

  final String? title;

  /// Optional descriptor shown below the title in caption style.
  final String? subtitle;

  final Widget? leading;
  final Widget? trailing;
  final double blurSigma;
  final bool showBorder;

  /// When true, draws a 2px accent-colored line at the very top of the bar.
  final bool showAccentLine;

  /// Height of the main bar content (excluding status bar).
  double get _barHeight => subtitle != null ? 52.0 : 44.0;

  @override
  Size get preferredSize => Size.fromHeight(_barHeight);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final accent = AppColors.accentRed.resolveFrom(context);
    final primary = AppColors.labelPrimary.resolveFrom(context);
    final secondary = AppColors.labelSecondary.resolveFrom(context);

    Widget titleArea = title != null
        ? subtitle != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title!,
                    style: AppTypography.headline.copyWith(color: primary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle!,
                    style: AppTypography.caption2.copyWith(color: secondary),
                    maxLines: 1,
                  ),
                ],
              )
            : Text(
                title!,
                style: AppTypography.headline.copyWith(color: primary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
        : const SizedBox.shrink();

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.glassBarBackground.resolveFrom(context),
            border: showBorder
                ? Border(
                    bottom: BorderSide(
                      color: AppColors.separator
                          .resolveFrom(context)
                          .withValues(alpha: 0.6),
                      width: 0.5,
                    ),
                  )
                : null,
          ),
          child: SizedBox(
            height: topPadding + _barHeight,
            child: Column(
              children: [
                // Accent top line (optional brand touch)
                if (showAccentLine)
                  Container(height: 2, color: accent),

                SizedBox(height: topPadding),

                // Navigation toolbar
                SizedBox(
                  height: _barHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Leading
                        SizedBox(
                          width: 80,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: leading != null
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: leading,
                                  )
                                : null,
                          ),
                        ),

                        // Center title
                        Expanded(child: Center(child: titleArea)),

                        // Trailing
                        SizedBox(
                          width: 80,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: trailing != null
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: trailing,
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A styled back/close button for use in [AppBarGlass.leading].
class AppBarLeadingButton extends StatelessWidget {
  const AppBarLeadingButton({
    super.key,
    this.label = 'Back',
    required this.onPressed,
    this.isClose = false,
  });

  final String label;
  final VoidCallback onPressed;

  /// When true, shows a circular ✕ icon instead of a text label.
  final bool isClose;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accentRed.resolveFrom(context);
    if (isClose) {
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.fillTertiary.resolveFrom(context),
            shape: BoxShape.circle,
          ),
          child: Icon(
            CupertinoIcons.xmark,
            size: 14,
            color: AppColors.labelSecondary.resolveFrom(context),
          ),
        ),
      );
    }

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(CupertinoIcons.chevron_left, color: accent, size: 17),
          const SizedBox(width: 2),
          Text(
            label,
            style: AppTypography.body.copyWith(color: accent),
          ),
        ],
      ),
    );
  }
}

/// A styled trailing icon-button for use in [AppBarGlass.trailing].
class AppBarTrailingButton extends StatelessWidget {
  const AppBarTrailingButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.label,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final activeColor =
        color ?? AppColors.accentRed.resolveFrom(context);

    if (label != null) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Text(
          label!,
          style: AppTypography.body.copyWith(
            color: onPressed == null
                ? AppColors.labelTertiary.resolveFrom(context)
                : activeColor,
          ),
        ),
      );
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.fillTertiary.resolveFrom(context),
        shape: BoxShape.circle,
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Icon(
          icon,
          size: 16,
          color: onPressed == null
              ? AppColors.labelTertiary.resolveFrom(context)
              : activeColor,
        ),
      ),
    );
  }
}
