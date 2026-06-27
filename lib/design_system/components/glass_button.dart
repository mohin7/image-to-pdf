import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

enum GlassButtonVariant { primary, secondary, destructive }

enum GlassButtonSize { regular, small, large }

class GlassButton extends StatefulWidget {
  const GlassButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.variant = GlassButtonVariant.primary,
    this.size = GlassButtonSize.regular,
    this.fullWidth = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final GlassButtonVariant variant;
  final GlassButtonSize size;
  final bool fullWidth;

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _pressed = false;

  EdgeInsets get _padding {
    return switch (widget.size) {
      GlassButtonSize.small => const EdgeInsets.symmetric(
          horizontal: AppSpacing.sp16,
          vertical: AppSpacing.sp8,
        ),
      GlassButtonSize.regular => const EdgeInsets.symmetric(
          horizontal: AppSpacing.sp24,
          vertical: AppSpacing.sp14,
        ),
      GlassButtonSize.large => const EdgeInsets.symmetric(
          horizontal: AppSpacing.sp32,
          vertical: AppSpacing.sp16,
        ),
    };
  }

  TextStyle get _labelStyle {
    return switch (widget.size) {
      GlassButtonSize.small => AppTypography.subheadlineMedium,
      GlassButtonSize.regular => AppTypography.bodyMedium,
      GlassButtonSize.large => AppTypography.headline,
    };
  }

  Color _backgroundColor(BuildContext context) {
    return switch (widget.variant) {
      GlassButtonVariant.primary =>
        AppColors.accentBlue.resolveFrom(context),
      GlassButtonVariant.secondary =>
        AppColors.glassBackground.resolveFrom(context),
      GlassButtonVariant.destructive =>
        AppColors.accentRed.resolveFrom(context),
    };
  }

  Color _foregroundColor(BuildContext context) {
    return switch (widget.variant) {
      GlassButtonVariant.primary => CupertinoColors.white,
      GlassButtonVariant.secondary =>
        AppColors.accentBlue.resolveFrom(context),
      GlassButtonVariant.destructive => CupertinoColors.white,
    };
  }

  Color _borderColor(BuildContext context) {
    return switch (widget.variant) {
      GlassButtonVariant.primary => CupertinoColors.transparent,
      GlassButtonVariant.secondary =>
        AppColors.glassBorder.resolveFrom(context),
      GlassButtonVariant.destructive => CupertinoColors.transparent,
    };
  }

  void _handleTap() {
    if (widget.onPressed == null || widget.isLoading) return;
    HapticFeedback.lightImpact();
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    Widget buttonChild = Row(
      mainAxisSize:
          widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          CupertinoActivityIndicator(
            color: _foregroundColor(context),
            radius: 8,
          ),
          const SizedBox(width: AppSpacing.sp8),
        ] else if (widget.icon != null) ...[
          Icon(
            widget.icon,
            color: _foregroundColor(context),
            size: widget.size == GlassButtonSize.small ? 16 : 18,
          ),
          const SizedBox(width: AppSpacing.sp6),
        ],
        Text(
          widget.label,
          style: _labelStyle.copyWith(
            color: _foregroundColor(context),
          ),
        ),
      ],
    );

    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: _handleTap,
        child: AnimatedScale(
          scale: _pressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _backgroundColor(context),
              borderRadius: AppRadius.radiusMD,
              border: Border.all(
                color: _borderColor(context),
                width: 0.5,
              ),
            ),
            child: Padding(padding: _padding, child: buttonChild),
          ),
        ),
      ),
    );
  }
}
