import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../services/file_service.dart';
import '../providers/pdf_preview_notifier.dart';

class PreviewActionBar extends ConsumerWidget {
  const PreviewActionBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(pdfPreviewProvider).result;
    if (result == null) return const SizedBox.shrink();

    final fileService = ref.read(fileServiceProvider);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 56.0 + bottomPadding,
          padding: EdgeInsets.fromLTRB(
            AppSpacing.sp24,
            0,
            AppSpacing.sp24,
            bottomPadding,
          ),
          decoration: BoxDecoration(
            color: AppColors.glassBarBackground.resolveFrom(context),
            border: Border(
              top: BorderSide(
                color: AppColors.separator
                    .resolveFrom(context)
                    .withValues(alpha: 0.6),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ActionButton(
                icon: CupertinoIcons.share,
                label: 'Share',
                onPressed: (rect) => fileService.shareFile(result, sharePositionOrigin: rect),
              ),
              Text(
                result.fileSizeDisplay,
                style: AppTypography.caption1.copyWith(
                  color: AppColors.labelSecondary.resolveFrom(context),
                ),
              ),
              _ActionButton(
                icon: CupertinoIcons.folder_badge_plus,
                label: 'Save to Files',
                onPressed: (rect) => fileService.saveToFiles(result, sharePositionOrigin: rect),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final void Function(Rect) onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sp12),
      onPressed: () {
        final box = context.findRenderObject() as RenderBox?;
        final origin = box != null
            ? box.localToGlobal(Offset.zero) & box.size
            : Rect.largest;
        onPressed(origin);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppColors.accentBlue.resolveFrom(context),
            size: 24,
          ),
          const SizedBox(height: AppSpacing.sp4),
          Text(
            label,
            style: AppTypography.caption1Medium.copyWith(
              color: AppColors.accentBlue.resolveFrom(context),
            ),
          ),
        ],
      ),
    );
  }
}
