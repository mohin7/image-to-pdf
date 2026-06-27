import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_radius.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../shared/models/page_size.dart';
import '../providers/pdf_settings_notifier.dart';

class PageSizeSection extends ConsumerWidget {
  const PageSizeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected =
        ref.watch(pdfSettingsProvider.select((s) => s.pageSize));
    final notifier = ref.read(pdfSettingsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel('PAGE SIZE'),
        const SizedBox(height: AppSpacing.sp8),
        Row(
          children: PageSize.values.map((size) {
            final isSelected = size == selected;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sp4),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    notifier.setPageSize(size);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sp12,
                      horizontal: AppSpacing.sp8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.accentBlue
                              .resolveFrom(context)
                              .withValues(alpha: 0.12)
                          : AppColors.fillQuaternary.resolveFrom(context),
                      borderRadius: AppRadius.radiusSM,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.accentBlue.resolveFrom(context)
                            : AppColors.glassBorder.resolveFrom(context),
                        width: isSelected ? 1.5 : 0.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _iconFor(size),
                          size: 22,
                          color: isSelected
                              ? AppColors.accentBlue.resolveFrom(context)
                              : AppColors.labelSecondary.resolveFrom(context),
                        ),
                        const SizedBox(height: AppSpacing.sp4),
                        Text(
                          size.displayName,
                          style: AppTypography.caption1Medium.copyWith(
                            color: isSelected
                                ? AppColors.accentBlue.resolveFrom(context)
                                : AppColors.labelPrimary.resolveFrom(context),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  IconData _iconFor(PageSize size) => switch (size) {
        PageSize.a4 => CupertinoIcons.doc,
        PageSize.letter => CupertinoIcons.doc_text,
        PageSize.fitToImage => CupertinoIcons.rectangle_expand_vertical,
      };
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.caption1Medium.copyWith(
        color: AppColors.labelSecondary.resolveFrom(context),
        letterSpacing: 0.5,
      ),
    );
  }
}
