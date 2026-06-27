import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../shared/models/pdf_settings.dart';
import '../providers/pdf_settings_notifier.dart';

class QualitySection extends ConsumerWidget {
  const QualitySection({super.key});

  static const _qualities = ImageQuality.values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected =
        ref.watch(pdfSettingsProvider.select((s) => s.quality));
    final notifier = ref.read(pdfSettingsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'IMAGE QUALITY',
              style: AppTypography.caption1Medium.copyWith(
                color: AppColors.labelSecondary.resolveFrom(context),
                letterSpacing: 0.5,
              ),
            ),
            Text(
              '${selected.displayName} (${selected.percent}%)',
              style: AppTypography.caption1.copyWith(
                color: AppColors.accentBlue.resolveFrom(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sp8),
        CupertinoSlider(
          value: _qualities.indexOf(selected).toDouble(),
          min: 0,
          max: (_qualities.length - 1).toDouble(),
          divisions: _qualities.length - 1,
          activeColor: AppColors.accentBlue.resolveFrom(context),
          onChanged: (value) {
            final index = value.round();
            final quality = _qualities[index];
            if (quality != selected) {
              HapticFeedback.selectionClick();
              notifier.setQuality(quality);
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sp4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _qualities.map((q) {
              return Text(
                q.displayName,
                style: AppTypography.caption2.copyWith(
                  color: q == selected
                      ? AppColors.accentBlue.resolveFrom(context)
                      : AppColors.labelTertiary.resolveFrom(context),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
