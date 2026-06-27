import 'package:flutter/cupertino.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_radius.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  final int currentPage;
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sp16,
        vertical: AppSpacing.sp6,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard.resolveFrom(context),
        borderRadius: AppRadius.radiusFull,
        border: Border.all(
          color: AppColors.separator.resolveFrom(context),
          width: 0.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        'Page $currentPage of $totalPages',
        style: AppTypography.footnoteMedium.copyWith(
          color: AppColors.labelPrimary.resolveFrom(context),
        ),
      ),
    );
  }
}
