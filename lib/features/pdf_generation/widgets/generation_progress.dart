import 'dart:math' as math;
import 'package:flutter/cupertino.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';

class GenerationProgress extends StatelessWidget {
  const GenerationProgress({
    super.key,
    required this.progress,
    required this.currentPage,
    required this.totalPages,
  });

  final double progress;
  final int currentPage;
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: CustomPaint(
            painter: _ProgressRingPainter(
              progress: progress,
              trackColor: AppColors.fillTertiary.resolveFrom(context),
              progressColor: AppColors.accentBlue.resolveFrom(context),
            ),
            child: Center(
              child: Text(
                '$percent%',
                style: AppTypography.title2Bold.copyWith(
                  color: AppColors.labelPrimary.resolveFrom(context),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sp24),
        Text(
          'Generating PDF…',
          style: AppTypography.headline.copyWith(
            color: AppColors.labelPrimary.resolveFrom(context),
          ),
        ),
        const SizedBox(height: AppSpacing.sp8),
        Text(
          totalPages > 0 ? 'Page $currentPage of $totalPages' : 'Preparing…',
          style: AppTypography.subheadline.copyWith(
            color: AppColors.labelSecondary.resolveFrom(context),
          ),
        ),
      ],
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  const _ProgressRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  final double progress;
  final Color trackColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 8) / 2;

    // Track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0
        ..strokeCap = StrokeCap.round,
    );

    // Progress arc
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6.0
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_ProgressRingPainter old) =>
      old.progress != progress ||
      old.trackColor != trackColor ||
      old.progressColor != progressColor;
}
