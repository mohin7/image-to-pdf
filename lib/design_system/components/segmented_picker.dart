import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// Wrapper around CupertinoSlidingSegmentedControl with haptic feedback.
class SegmentedPicker<T extends Object> extends StatelessWidget {
  const SegmentedPicker({
    super.key,
    required this.children,
    required this.value,
    required this.onChanged,
  });

  final Map<T, Widget> children;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<T>(
      children: children,
      groupValue: value,
      backgroundColor: AppColors.fillTertiary.resolveFrom(context),
      thumbColor: AppColors.surfaceSecondary.resolveFrom(context),
      onValueChanged: (v) {
        if (v != null) {
          HapticFeedback.selectionClick();
          onChanged(v);
        }
      },
    );
  }
}

/// Convenience factory for text-only segments.
Widget segmentLabel(String text, BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Text(
        text,
        style: AppTypography.subheadlineMedium.copyWith(
          color: AppColors.labelPrimary.resolveFrom(context),
        ),
      ),
    );
