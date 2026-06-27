import 'package:flutter/cupertino.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sp32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.labelTertiary.resolveFrom(context),
            ),
            const SizedBox(height: AppSpacing.sp16),
            Text(
              title,
              style: AppTypography.headline.copyWith(
                color: AppColors.labelPrimary.resolveFrom(context),
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.sp8),
              Text(
                subtitle!,
                style: AppTypography.subheadline.copyWith(
                  color: AppColors.labelSecondary.resolveFrom(context),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppSpacing.sp24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
