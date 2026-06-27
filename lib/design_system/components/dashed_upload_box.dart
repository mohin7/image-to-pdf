import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_typography.dart';

class DashedUploadBox extends StatefulWidget {
  const DashedUploadBox({
    super.key,
    required this.onTap,
    this.title = 'Tap or click here to choose a PDF file.',
    this.subtitle,
    this.icon = CupertinoIcons.doc_fill,
    this.isSelected = false,
    this.selectedLabel,
    this.showChooseButton = true,
  });

  final VoidCallback onTap;
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool isSelected;
  final String? selectedLabel;
  final bool showChooseButton;

  @override
  State<DashedUploadBox> createState() => _DashedUploadBoxState();
}

class _DashedUploadBoxState extends State<DashedUploadBox> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final accentColor = AppColors.accentRed.resolveFrom(context);
    final borderColor = widget.isSelected
        ? accentColor
        : AppColors.labelTertiary.resolveFrom(context);

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: CustomPaint(
          painter: _DashedBorderPainter(color: borderColor),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? accentColor.withValues(alpha: 0.08)
                  : AppColors.surfaceInput.resolveFrom(context),
              borderRadius: AppRadius.radiusMD,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? accentColor.withValues(alpha: 0.12)
                        : AppColors.separator
                            .resolveFrom(context)
                            .withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.isSelected
                        ? CupertinoIcons.checkmark_circle_fill
                        : widget.icon,
                    size: 26,
                    color: widget.isSelected ? accentColor : borderColor,
                  ),
                ),
                const SizedBox(height: 12),
                if (widget.isSelected && widget.selectedLabel != null)
                  Text(
                    widget.selectedLabel!,
                    style: AppTypography.subheadline
                        .copyWith(color: accentColor, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  )
                else ...[
                  Text(
                    widget.title,
                    style: AppTypography.subheadline.copyWith(
                      color: AppColors.labelSecondary.resolveFrom(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle!,
                      style: AppTypography.footnote.copyWith(
                        color: AppColors.labelTertiary.resolveFrom(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  if (widget.showChooseButton) ...[
                    const SizedBox(height: 16),
                    _ChoosePill(accentColor: accentColor),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoosePill extends StatelessWidget {
  const _ChoosePill({required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: AppRadius.radiusFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(CupertinoIcons.plus_circle_fill,
              size: 14, color: CupertinoColors.white),
          const SizedBox(width: 6),
          Text(
            'Choose',
            style: AppTypography.footnoteMedium.copyWith(
              color: CupertinoColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    const radius = 14.0;
    const strokeWidth = 1.5;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(radius));

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final end = math.min(distance + dashWidth, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => old.color != color;
}
