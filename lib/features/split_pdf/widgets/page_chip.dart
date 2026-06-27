import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_typography.dart';

class PageChip extends StatelessWidget {
  const PageChip({
    super.key,
    required this.pageNumber,
    required this.isSelected,
    required this.onTap,
  });

  final int pageNumber; // 1-based display
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accentColor = AppColors.accentRed.resolveFrom(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor
              : AppColors.surfaceCard.resolveFrom(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? accentColor
                : AppColors.separator.resolveFrom(context),
            width: isSelected ? 1.5 : 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.doc,
                size: 22,
                color: isSelected
                    ? CupertinoColors.white
                    : AppColors.labelTertiary.resolveFrom(context),
              ),
              const SizedBox(height: 4),
              Text(
                '$pageNumber',
                style: AppTypography.caption1.copyWith(
                  color: isSelected
                      ? CupertinoColors.white
                      : AppColors.labelPrimary.resolveFrom(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: (pageNumber % 12) * 20))
        .fadeIn(duration: const Duration(milliseconds: 250))
        .scaleXY(
          begin: 0.85,
          end: 1.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
        );
  }
}
