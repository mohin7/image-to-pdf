import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/components/segmented_picker.dart';
import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../shared/models/pdf_settings.dart';
import '../providers/pdf_settings_notifier.dart';

class MarginSection extends ConsumerWidget {
  const MarginSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected =
        ref.watch(pdfSettingsProvider.select((s) => s.margin));
    final notifier = ref.read(pdfSettingsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PAGE MARGINS',
          style: AppTypography.caption1Medium.copyWith(
            color: AppColors.labelSecondary.resolveFrom(context),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.sp8),
        SizedBox(
          width: double.infinity,
          child: SegmentedPicker<PageMargin>(
            value: selected,
            onChanged: notifier.setMargin,
            children: {
              for (final m in PageMargin.values)
                m: segmentLabel(m.displayName, context),
            },
          ),
        ),
      ],
    );
  }
}
