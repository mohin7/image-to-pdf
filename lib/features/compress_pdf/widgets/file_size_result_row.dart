import 'package:flutter/cupertino.dart';

import '../../../design_system/components/flat_card.dart';
import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../shared/models/pdf_document.dart';
import '../../../shared/models/pdf_result.dart';

class FileSizeResultRow extends StatelessWidget {
  const FileSizeResultRow({
    super.key,
    required this.original,
    required this.compressed,
  });

  final PdfDocument original;
  final PdfResult compressed;

  @override
  Widget build(BuildContext context) {
    final saved = original.fileSizeBytes - compressed.fileSizeBytes;
    final pct = saved > 0
        ? (saved / original.fileSizeBytes * 100).toStringAsFixed(0)
        : '0';

    return FlatCard(
      padding: const EdgeInsets.all(AppSpacing.sp16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SizeChip(
                label: 'Original',
                size: original.fileSizeDisplay,
                color: AppColors.labelSecondary.resolveFrom(context),
              ),
              Icon(
                CupertinoIcons.arrow_right,
                size: 16,
                color: AppColors.labelTertiary.resolveFrom(context),
              ),
              _SizeChip(
                label: 'Compressed',
                size: compressed.fileSizeDisplay,
                color: AppColors.accentGreen.resolveFrom(context),
              ),
            ],
          ),
          if (saved > 0) ...[
            const SizedBox(height: AppSpacing.sp12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sp12,
                vertical: AppSpacing.sp6,
              ),
              decoration: BoxDecoration(
                color: AppColors.accentGreen
                    .resolveFrom(context)
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Reduced by $pct%',
                style: AppTypography.footnote.copyWith(
                  color: AppColors.accentGreen.resolveFrom(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SizeChip extends StatelessWidget {
  const _SizeChip({
    required this.label,
    required this.size,
    required this.color,
  });

  final String label;
  final String size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.caption1.copyWith(
            color: AppColors.labelSecondary.resolveFrom(context),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          size,
          style: AppTypography.subheadline
              .copyWith(color: color, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
