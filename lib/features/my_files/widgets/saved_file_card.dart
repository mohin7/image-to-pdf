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
    return Dismissible(
      key: ValueKey(result.filePath),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _confirmDelete(context);
        } else if (direction == DismissDirection.startToEnd) {
          _share(context, result);
          return false;
        }
        return false;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          ref.read(savedFilesProvider.notifier).delete(result);
        }
      },
      background: Container(
        decoration: BoxDecoration(
          color: AppColors.accentBlue.resolveFrom(context),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: AppSpacing.sp24),
        child: const Icon(
          CupertinoIcons.share,
          color: CupertinoColors.white,
          size: 24,
        ),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: AppColors.destructive.resolveFrom(context),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.sp24),
        child: const Icon(
          CupertinoIcons.trash,
          color: CupertinoColors.white,
          size: 24,
        ),
      ),
      child: GestureDetector(
        onTap: () => _showRenameDialog(context, ref),
        behavior: HitTestBehavior.opaque,
        child: FlatCard(
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
                      '${result.fileSizeDisplay} • ${_formatDate(result.generatedAt)}',
                      style: AppTypography.caption1.copyWith(
                        color: AppColors.labelSecondary.resolveFrom(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sp8),
              SizedBox(
                width: 36,
                height: 36,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _showRenameDialog(context, ref),
                  child: Icon(
                    CupertinoIcons.square_pencil,
                    size: 20,
                    color: AppColors.labelSecondary.resolveFrom(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;

    var hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    if (hour == 0) hour = 12;
    if (hour > 12) hour -= 12;

    return '$day $month $year, $hour:$minute $period';
  }

  void _share(BuildContext context, PdfResult result) {
    final box = context.findRenderObject() as RenderBox?;
    final origin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : Rect.largest;
    Share.shareXFiles(
      [XFile(result.filePath, mimeType: 'application/pdf')],
      subject: result.fileName,
      sharePositionOrigin: origin,
    );
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(
      text: result.fileName.replaceAll('.pdf', ''),
    );
    showCupertinoDialog<void>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Rename PDF'),
        content: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.sp12),
          child: CupertinoTextField(
            controller: controller,
            placeholder: 'New file name',
            autofocus: true,
            style: AppTypography.body.copyWith(
              color: AppColors.labelPrimary.resolveFrom(context),
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              final newName = controller.text;
              if (newName.isNotEmpty) {
                ref.read(savedFilesProvider.notifier).rename(result, newName);
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final didConfirm = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Delete PDF?'),
        content: Text('${result.fileName} will be permanently deleted.'),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
    return didConfirm ?? false;
  }
}
