import 'package:flutter/cupertino.dart';

import '../../../design_system/components/glass_button.dart';
import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';

class GenerationErrorView extends StatelessWidget {
  const GenerationErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    required this.onCancel,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          CupertinoIcons.exclamationmark_triangle_fill,
          size: 56,
          color: AppColors.accentRed.resolveFrom(context),
        ),
        const SizedBox(height: AppSpacing.sp16),
        Text(
          'Generation Failed',
          style: AppTypography.headline.copyWith(
            color: AppColors.labelPrimary.resolveFrom(context),
          ),
        ),
        const SizedBox(height: AppSpacing.sp8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sp32),
          child: Text(
            message,
            style: AppTypography.subheadline.copyWith(
              color: AppColors.labelSecondary.resolveFrom(context),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppSpacing.sp32),
        GlassButton(
          label: 'Try Again',
          icon: CupertinoIcons.refresh,
          onPressed: onRetry,
          variant: GlassButtonVariant.primary,
        ),
        const SizedBox(height: AppSpacing.sp12),
        CupertinoButton(
          onPressed: onCancel,
          child: Text(
            'Cancel',
            style: AppTypography.body.copyWith(
              color: AppColors.labelSecondary.resolveFrom(context),
            ),
          ),
        ),
      ],
    );
  }
}
