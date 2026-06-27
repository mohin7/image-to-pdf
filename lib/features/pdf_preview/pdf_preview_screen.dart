import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/components/app_bar_glass.dart';
import '../../design_system/tokens/app_colors.dart';
import '../../design_system/tokens/app_spacing.dart';
import '../home/providers/image_list_notifier.dart';
import '../pdf_generation/providers/pdf_generation_notifier.dart';
import 'providers/pdf_preview_notifier.dart';
import 'widgets/page_indicator.dart';
import 'widgets/pdf_viewer_widget.dart';
import 'widgets/preview_action_bar.dart';

class PdfPreviewScreen extends ConsumerWidget {
  const PdfPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewState = ref.watch(pdfPreviewProvider);
    final result = previewState.result;

    return CupertinoPageScaffold(
      backgroundColor: AppColors.surfacePrimary.resolveFrom(context),
      child: Stack(
        children: [
          // PDF viewer fills full screen, scrolling behind bars
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 44.0,
                bottom: 56.0 + MediaQuery.of(context).padding.bottom,
              ),
              child: const PdfViewerWidget(),
            ),
          ),

          // Glass nav bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBarGlass(
              title: result?.fileName ?? 'PDF Preview',
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  ref.read(imageListProvider.notifier).clearAll();
                  ref.read(pdfGenerationProvider.notifier).reset();
                  ref.read(pdfPreviewProvider.notifier).reset();
                  Navigator.of(context).popUntil((r) => r.isFirst);
                },
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: AppColors.accentBlue.resolveFrom(context),
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          // Page indicator floating pill
          if (result != null)
            Positioned(
              bottom:
                  56.0 + MediaQuery.of(context).padding.bottom + AppSpacing.sp12,
              left: 0,
              right: 0,
              child: Center(
                child: PageIndicator(
                  currentPage: previewState.currentPage,
                  totalPages: result.pageCount,
                ),
              )
                  .animate()
                  .fadeIn(
                    delay: const Duration(milliseconds: 500),
                    duration: const Duration(milliseconds: 400),
                  ),
            ),

          // Glass bottom action bar
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: PreviewActionBar(),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 300))
        .slideY(
          begin: 0.03,
          end: 0.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
  }
}
