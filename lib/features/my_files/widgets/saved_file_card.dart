import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../design_system/components/flat_card.dart';
import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../shared/models/pdf_result.dart';
import '../providers/saved_files_notifier.dart';

class SavedFileCard extends ConsumerWidget {
  const SavedFileCard({super.key, required this.result});

  final PdfResult result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlatCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sp16,
        vertical: AppSpacing.sp12,
      ),
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
                    color: AppColors.labelPrimary.resolveFrom(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  result.fileSizeDisplay,
                  style: AppTypography.caption1.copyWith(
                    color: AppColors.labelSecondary.resolveFrom(context),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 44,
                height: 44,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _share(result),
                  child: Icon(
                    CupertinoIcons.share,
                    size: 20,
                    color: AppColors.accentBlue.resolveFrom(context),
                  ),
                ),
              ),
              SizedBox(
                width: 44,
                height: 44,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _confirmDelete(context, ref),
                  child: Icon(
                    CupertinoIcons.trash,
                    size: 20,
                    color: AppColors.destructive.resolveFrom(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _share(PdfResult result) {
    Share.shareXFiles(
      [XFile(result.filePath, mimeType: 'application/pdf')],
      subject: result.fileName,
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showCupertinoDialog<void>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Delete PDF?'),
        content: Text('${result.fileName} will be permanently deleted.'),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(savedFilesProvider.notifier).delete(result);
            },
            child: const Text('Delete'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
