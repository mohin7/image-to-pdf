import 'package:flutter/cupertino.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_radius.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../shared/models/compression_level.dart';

class CompressionOptionCard extends StatelessWidget {
  const CompressionOptionCard({
    super.key,
    required this.level,
    required this.isSelected,
    required this.onTap,
  });

  final CompressionLevel level;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accentRed.resolveFrom(context);
    final borderColor =
        isSelected ? accent : AppColors.separator.resolveFrom(context);
    final bgColor = isSelected
        ? accent.withValues(alpha: 0.10)
        : AppColors.surfaceCard.resolveFrom(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppRadius.radiusMD,
          border: Border.all(
            color: borderColor,
            width: isSelected ? 1.5 : 0.8,
          ),
          boxShadow: isSelected
              ? null
              : [
                  BoxShadow(
                    color: CupertinoColors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: AppRadius.radiusMD,
          child: Row(
            children: [
              // Left accent bar — only visible when selected
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: isSelected ? 4 : 0,
                color: accent,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sp16,
                    vertical: AppSpacing.sp14,
                  ),
                  child: Row(
                    children: [
                      // Radio circle
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? accent : CupertinoColors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? accent
                                : AppColors.labelTertiary.resolveFrom(context),
                            width: isSelected ? 0 : 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                CupertinoIcons.checkmark,
                                size: 13,
                                color: CupertinoColors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: AppSpacing.sp12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              level.label,
                              style: AppTypography.subheadline.copyWith(
                                color: isSelected
                                    ? accent
                                    : AppColors.labelPrimary.resolveFrom(context),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              level.description,
                              style: AppTypography.caption1.copyWith(
                                color: AppColors.labelSecondary.resolveFrom(context),
                              ),
                            ),
                          ],
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
    );
  }
}
