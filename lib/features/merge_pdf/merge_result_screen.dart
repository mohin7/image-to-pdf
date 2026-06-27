import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';

import '../../design_system/components/flat_card.dart';
import '../../design_system/components/primary_button.dart';
import '../../design_system/tokens/app_colors.dart';
import '../../design_system/tokens/app_spacing.dart';
import '../../design_system/tokens/app_typography.dart';
import '../../shared/models/pdf_result.dart';

class MergeResultScreen extends StatelessWidget {
  const MergeResultScreen({
    super.key,
    required this.result,
    required this.mergedCount,
  });

  final PdfResult result;
  final int mergedCount;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.backgroundPrimary.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.tabBarBackground.resolveFrom(context),
        border: const Border(),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Back',
            style: TextStyle(
              color: AppColors.accentRed.resolveFrom(context),
            ),
          ),
        ),
        middle: Text(
          'Merge Result',
          style: AppTypography.headline.copyWith(
            color: AppColors.labelPrimary.resolveFrom(context),
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sp24),
          child: Column(
            children: [
              const Spacer(),

              // Success icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.accentGreen
                      .resolveFrom(context)
                      .withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  CupertinoIcons.checkmark_circle_fill,
                  size: 48,
                  color: AppColors.accentGreen.resolveFrom(context),
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.6, 0.6),
                    end: const Offset(1.0, 1.0),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(duration: const Duration(milliseconds: 200)),

              const SizedBox(height: AppSpacing.sp20),
              Text(
                'Merge Successful!',
                style: AppTypography.title2.copyWith(
                  color: AppColors.labelPrimary.resolveFrom(context),
                  fontWeight: FontWeight.w700,
                ),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: AppSpacing.sp8),
              Text(
                '$mergedCount PDFs merged  ·  ${result.pageCount} pages  ·  ${result.fileSizeDisplay}',
                style: AppTypography.subheadline.copyWith(
                  color: AppColors.labelSecondary.resolveFrom(context),
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 300.ms),

              const SizedBox(height: AppSpacing.sp32),

              // File summary card
              FlatCard(
                padding: const EdgeInsets.all(AppSpacing.sp16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.accentRed
                            .resolveFrom(context)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        CupertinoIcons.doc_fill,
                        color: AppColors.accentRed.resolveFrom(context),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sp12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            result.fileName,
                            style: AppTypography.subheadline.copyWith(
                              color:
                                  AppColors.labelPrimary.resolveFrom(context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            result.fileSizeDisplay,
                            style: AppTypography.caption1.copyWith(
                              color: AppColors.labelSecondary
                                  .resolveFrom(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),

              const Spacer(),

              // Actions
              PrimaryButton(
                label: 'Share / Save to Files',
                icon: CupertinoIcons.share,
                onPressed: () => Share.shareXFiles(
                  [XFile(result.filePath, mimeType: 'application/pdf')],
                  subject: result.fileName,
                ),
              ),
              const SizedBox(height: AppSpacing.sp12),
              PrimaryButton(
                label: 'Done',
                variant: PrimaryButtonVariant.outline,
                onPressed: () =>
                    Navigator.of(context).popUntil((r) => r.isFirst),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
