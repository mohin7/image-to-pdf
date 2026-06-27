import 'package:flutter/cupertino.dart';

import '../../../design_system/components/flat_card.dart';
import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../shared/models/pdf_document.dart';

class PdfFileListItem extends StatelessWidget {
  const PdfFileListItem({
    super.key,
    required this.doc,
    required this.onRemove,
    this.showDragHandle = true,
  });

  final PdfDocument doc;
  final VoidCallback onRemove;
  final bool showDragHandle;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accentRed.resolveFrom(context);

    return FlatCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sp14,
        vertical: AppSpacing.sp12,
      ),
      child: Row(
        children: [
          if (showDragHandle)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sp10),
              child: Icon(
                CupertinoIcons.line_horizontal_3,
                size: 18,
                color: AppColors.labelTertiary.resolveFrom(context),
              ),
            ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              CupertinoIcons.doc_fill,
              color: accent,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.sp12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.fileName,
                  style: AppTypography.subheadline.copyWith(
                    color: AppColors.labelPrimary.resolveFrom(context),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  doc.pageCount > 0
                      ? '${doc.pageCount} Pages  ·  ${doc.fileSizeDisplay}'
                      : doc.fileSizeDisplay,
                  style: AppTypography.caption1.copyWith(
                    color: AppColors.labelSecondary.resolveFrom(context),
                  ),
                ),
              ],
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onRemove,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: AppColors.fillTertiary.resolveFrom(context),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.xmark,
                size: 13,
                color: AppColors.labelSecondary.resolveFrom(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
