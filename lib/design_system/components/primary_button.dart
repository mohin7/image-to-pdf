import 'package:flutter/cupertino.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_typography.dart';

enum PrimaryButtonVariant { filled, outline, ghost }

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = PrimaryButtonVariant.filled,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final PrimaryButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final Color? color;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  void _onTapDown(TapDownDetails _) => setState(() => _pressed = true);
  void _onTapUp(TapUpDetails _) => setState(() => _pressed = false);
  void _onTapCancel() => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.color ?? AppColors.accentRed.resolveFrom(context);
    final isDisabled = widget.onPressed == null && !widget.isLoading;

    final Color bgColor;
    final Color textColor;
    final Border? border;

    switch (widget.variant) {
      case PrimaryButtonVariant.filled:
        bgColor = isDisabled
            ? AppColors.labelTertiary.resolveFrom(context)
            : accentColor;
        textColor = CupertinoColors.white;
        border = null;
      case PrimaryButtonVariant.outline:
        bgColor = CupertinoColors.transparent;
        textColor = isDisabled
            ? AppColors.labelTertiary.resolveFrom(context)
            : accentColor;
        border = Border.all(
          color: isDisabled
              ? AppColors.labelTertiary.resolveFrom(context)
              : accentColor,
          width: 1.5,
        );
      case PrimaryButtonVariant.ghost:
        bgColor = CupertinoColors.transparent;
        textColor = isDisabled
            ? AppColors.labelTertiary.resolveFrom(context)
            : accentColor;
        border = null;
    }

    Widget content;
    if (widget.isLoading) {
      content = CupertinoActivityIndicator(color: textColor);
    } else if (widget.icon != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, color: textColor, size: 18),
          const SizedBox(width: 8),
          Text(widget.label,
              style: AppTypography.headline.copyWith(color: textColor)),
        ],
      );
    } else {
      content = Text(widget.label,
          style: AppTypography.headline.copyWith(color: textColor));
    }

    Widget button = AnimatedScale(
      scale: _pressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 120),
      child: GestureDetector(
        onTapDown: isDisabled ? null : _onTapDown,
        onTapUp: isDisabled ? null : _onTapUp,
        onTapCancel: isDisabled ? null : _onTapCancel,
        onTap: isDisabled ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: AppRadius.radiusFull,
            border: border,
            boxShadow: widget.variant == PrimaryButtonVariant.filled && !isDisabled
                ? [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: content,
        ),
      ),
    );

    if (widget.fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
