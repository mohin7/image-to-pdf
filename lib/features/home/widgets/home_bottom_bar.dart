import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/components/primary_button.dart';
import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_spacing.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../providers/image_list_notifier.dart';

class HomeBottomBar extends ConsumerWidget {
  const HomeBottomBar({
    super.key,
    required this.onConvert,
    required this.onAdd,
  });

  final VoidCallback onConvert;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(imageCountProvider);
    final canConvert = ref.watch(canConvertProvider);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    if (!canConvert) return const SizedBox.shrink();

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.sp16,
            AppSpacing.sp10,
            AppSpacing.sp16,
            AppSpacing.sp10 + bottomPadding,
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
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onAdd,
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.plus_circle_fill,
                      color: AppColors.accentRed.resolveFrom(context),
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sp6),
                    Text(
                      '$count ${count == 1 ? 'image' : 'images'}',
                      style: AppTypography.subheadline.copyWith(
                        color: AppColors.labelSecondary.resolveFrom(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Convert to PDF',
                icon: CupertinoIcons.doc_richtext,
                fullWidth: false,
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  onConvert();
                },
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .slideY(
          begin: 1.0,
          end: 0.0,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        )
        .fadeIn(duration: const Duration(milliseconds: 200));
  }
}
