import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/components/primary_button.dart';
import '../../design_system/tokens/app_colors.dart';
import '../../design_system/tokens/app_radius.dart';
import '../../design_system/tokens/app_spacing.dart';
import '../../design_system/tokens/app_typography.dart';
import 'widgets/margin_section.dart';
import 'widgets/orientation_section.dart';
import 'widgets/page_size_section.dart';
import 'widgets/quality_section.dart';

class PdfSettingsSheet extends ConsumerWidget {
  const PdfSettingsSheet({super.key, required this.onGenerate});

  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard.resolveFrom(context),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xl),
          topRight: Radius.circular(AppRadius.xl),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag indicator
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sp12),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.fillPrimary.resolveFrom(context),
                  borderRadius: AppRadius.radiusFull,
                ),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sp16,
                vertical: AppSpacing.sp12,
              ),
              child: Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: AppTypography.body.copyWith(
                        color: AppColors.accentRed.resolveFrom(context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'PDF Settings',
                      style: AppTypography.headline.copyWith(
                        color: AppColors.labelPrimary.resolveFrom(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Invisible placeholder to center the title
                  const SizedBox(width: 64),
                ],
              ),
            ),

            // Divider
            Container(
              height: 0.5,
              color: AppColors.separator.resolveFrom(context),
            ),

            // Settings sections
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.sp16,
                  AppSpacing.sp24,
                  AppSpacing.sp16,
                  AppSpacing.sp16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageSizeSection(),
                    const SizedBox(height: AppSpacing.sp24),
                    const OrientationSection(),
                    const SizedBox(height: AppSpacing.sp24),
                    const QualitySection(),
                    const SizedBox(height: AppSpacing.sp24),
                    const MarginSection(),
                    const SizedBox(height: AppSpacing.sp32),

                    // Generate CTA
                    PrimaryButton(
                      label: 'Generate PDF',
                      icon: CupertinoIcons.wand_stars,
                      onPressed: onGenerate,
                    ),

                    SizedBox(height: bottomPadding),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .slideY(
          begin: 0.1,
          end: 0.0,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        )
        .fadeIn(duration: const Duration(milliseconds: 250));
  }
}
