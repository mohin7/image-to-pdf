import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/components/app_bar_glass.dart';
import '../../design_system/components/primary_button.dart';
import '../../design_system/tokens/app_colors.dart';
import '../../design_system/tokens/app_spacing.dart';
import '../../design_system/tokens/app_typography.dart';
import '../../features/pdf_generation/pdf_generation_screen.dart';
import '../pdf_settings/pdf_settings_sheet.dart';
import 'providers/image_list_notifier.dart';
import 'widgets/home_bottom_bar.dart';
import 'widgets/image_grid.dart';
import 'widgets/source_picker_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canConvert = ref.watch(canConvertProvider);
    final notifier = ref.read(imageListProvider.notifier);
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    const barContentHeight = 60.0;
    final bottomInset = canConvert ? barContentHeight + bottomPadding : 0.0;

    return CupertinoPageScaffold(
      backgroundColor: AppColors.backgroundPrimary.resolveFrom(context),
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _NavBarSpacer()),
              SliverToBoxAdapter(child: _HeroSection()),
              if (!canConvert)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(onAdd: () => showSourcePicker(context)),
                )
              else
                SliverFillRemaining(
                  hasScrollBody: true,
                  child: ImageGrid(bottomInset: bottomInset),
                ),
            ],
          ),

          // Flat nav bar overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBarGlass(
              title: 'Image to PDF',
              trailing: canConvert
                  ? CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => _confirmClearAll(context, notifier),
                      child: Icon(
                        CupertinoIcons.trash,
                        color: AppColors.accentRed.resolveFrom(context),
                        size: 20,
                      ),
                    )
                  : null,
            ),
          ),

          // Flat bottom action bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: HomeBottomBar(
              onAdd: () => showSourcePicker(context),
              onConvert: () => _showSettings(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => PdfSettingsSheet(
        onGenerate: () {
          Navigator.of(ctx).pop();
          Navigator.of(context).push(
            CupertinoPageRoute<void>(
              builder: (_) => const PdfGenerationScreen(),
            ),
          );
        },
      ),
    );
  }

  void _confirmClearAll(BuildContext context, ImageListNotifier notifier) {
    HapticFeedback.mediumImpact();
    showCupertinoDialog<void>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Clear All Images?'),
        content: const Text('This will remove all selected images.'),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(ctx).pop();
              notifier.clearAll();
            },
            child: const Text('Clear All'),
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

class _NavBarSpacer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return SizedBox(height: topPadding + 44.0);
  }
}

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accentRed.resolveFrom(context);
    final primary = AppColors.labelPrimary.resolveFrom(context);
    final secondary = AppColors.labelSecondary.resolveFrom(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.sp16, AppSpacing.sp20, AppSpacing.sp16, AppSpacing.sp4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Accent pill / brand indicator
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.sp12),
          RichText(
            text: TextSpan(
              style: AppTypography.title1Bold.copyWith(color: primary),
              children: [
                const TextSpan(text: 'Convert Images to '),
                TextSpan(text: 'PDF', style: TextStyle(color: accent)),
                const TextSpan(text: '.'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sp8),
          Text(
            'Add photos from your library and turn them into a PDF in seconds.',
            style: AppTypography.subheadline.copyWith(color: secondary),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accentRed.resolveFrom(context);
    final secondary = AppColors.labelSecondary.resolveFrom(context);
    final primary = AppColors.labelPrimary.resolveFrom(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sp32,
        vertical: AppSpacing.sp16,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.photo_on_rectangle,
              size: 48,
              color: accent,
            ),
          ),
          const SizedBox(height: AppSpacing.sp20),
          Text(
            'No Images Yet',
            style: AppTypography.title3Semibold.copyWith(color: primary),
          ),
          const SizedBox(height: AppSpacing.sp8),
          Text(
            'Tap below to add photos from your library or camera.',
            style: AppTypography.subheadline.copyWith(color: secondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sp32),
          PrimaryButton(
            label: 'Add Images',
            icon: CupertinoIcons.photo,
            onPressed: onAdd,
            fullWidth: false,
          ),
        ],
      ),
    );
  }
}
