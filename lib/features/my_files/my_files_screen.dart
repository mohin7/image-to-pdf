import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/components/app_bar_glass.dart';
import '../../design_system/tokens/app_colors.dart';
import '../../design_system/tokens/app_spacing.dart';
import '../../design_system/tokens/app_typography.dart';
import 'providers/saved_files_notifier.dart';
import 'widgets/saved_file_card.dart';

class MyFilesScreen extends ConsumerStatefulWidget {
  const MyFilesScreen({super.key});

  @override
  ConsumerState<MyFilesScreen> createState() => _MyFilesScreenState();
}

class _MyFilesScreenState extends ConsumerState<MyFilesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(savedFilesProvider.notifier).load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final files = ref.watch(savedFilesProvider);

    return CupertinoPageScaffold(
      backgroundColor: AppColors.backgroundPrimary.resolveFrom(context),
      child: Stack(
        children: [
          // Content
          files.isEmpty
              ? _EmptyState()
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.of(context).padding.top + 44,
                      ),
                    ),
                    CupertinoSliverRefreshControl(
                      onRefresh: () =>
                          ref.read(savedFilesProvider.notifier).load(),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.sp16,
                        AppSpacing.sp16,
                        AppSpacing.sp16,
                        AppSpacing.sp16 + MediaQuery.of(context).padding.bottom,
                      ),
                      sliver: SliverList.separated(
                        itemCount: files.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.sp8),
                        itemBuilder: (_, i) => SavedFileCard(result: files[i]),
                      ),
                    ),
                  ],
                ),

          // Glass nav bar overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBarGlass(
              title: 'My Files',
              subtitle: files.isEmpty ? null : '${files.length} PDFs',
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tertiary = AppColors.labelTertiary.resolveFrom(context);
    final primary = AppColors.labelPrimary.resolveFrom(context);
    final secondary = AppColors.labelSecondary.resolveFrom(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sp32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                color: tertiary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.folder,
                size: 48,
                color: tertiary,
              ),
            ),
            const SizedBox(height: AppSpacing.sp20),
            Text(
              'No PDFs Yet',
              style: AppTypography.title3Semibold.copyWith(
                color: primary,
              ),
            ),
            const SizedBox(height: AppSpacing.sp8),
            Text(
              'PDFs you convert, merge, or compress will appear here.',
              style: AppTypography.subheadline.copyWith(
                color: secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
