import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';

import '../../../design_system/components/flat_card.dart';
import '../../../design_system/components/primary_button.dart';
import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../shared/models/pdf_result.dart';

class SplitResultList extends StatelessWidget {
  const SplitResultList({super.key, required this.results});

  final List<PdfResult> results;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              CupertinoIcons.checkmark_circle_fill,
              size: 20,
              color: AppColors.accentGreen.resolveFrom(context),
            ),
            const SizedBox(width: AppSpacing.sp8),
            Text(
              '${results.length} file${results.length == 1 ? '' : 's'} extracted',
              style: AppTypography.subheadline.copyWith(
                color: AppColors.labelPrimary.resolveFrom(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sp12),
        ...results.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sp8),
              child: FlatCard(
                padding: const EdgeInsets.all(AppSpacing.sp12),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.doc_fill,
                      color: AppColors.accentRed.resolveFrom(context),
                      size: 24,
                    ),
                    const SizedBox(width: AppSpacing.sp12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.fileName,
                            style: AppTypography.footnote.copyWith(
                              color:
                                  AppColors.labelPrimary.resolveFrom(context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${r.pageCount} pages · ${r.fileSizeDisplay}',
                            style: AppTypography.caption2.copyWith(
                              color: AppColors.labelSecondary
                                  .resolveFrom(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Share.shareXFiles(
                        [XFile(r.filePath, mimeType: 'application/pdf')],
                        subject: r.fileName,
                      ),
                      child: Icon(
                        CupertinoIcons.share,
                        size: 18,
                        color: AppColors.accentBlue.resolveFrom(context),
                      ),
                    ),
                  ],
                ),
              ),
            )),
        const SizedBox(height: AppSpacing.sp8),
        PrimaryButton(
          label: 'Share All',
          icon: CupertinoIcons.share,
          variant: PrimaryButtonVariant.outline,
          onPressed: () => Share.shareXFiles(
            results
                .map((r) => XFile(r.filePath, mimeType: 'application/pdf'))
                .toList(),
          ),
        ),
      ],
    );
  }
}
