import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/haptic_utils.dart';
import '../../design_system/tokens/app_colors.dart';
import '../../design_system/tokens/app_spacing.dart';
import '../home/providers/image_list_notifier.dart';
import '../pdf_preview/pdf_preview_screen.dart';
import '../pdf_settings/providers/pdf_settings_notifier.dart';
import '../pdf_preview/providers/pdf_preview_notifier.dart';
import 'providers/pdf_generation_notifier.dart';
import 'widgets/generation_error_view.dart';
import 'widgets/generation_progress.dart';

class PdfGenerationScreen extends ConsumerStatefulWidget {
  const PdfGenerationScreen({super.key});

  @override
  ConsumerState<PdfGenerationScreen> createState() =>
      _PdfGenerationScreenState();
}

class _PdfGenerationScreenState extends ConsumerState<PdfGenerationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startGeneration());
  }

  void _startGeneration() {
    final images = ref.read(imageListProvider);
    final settings = ref.read(pdfSettingsProvider);
    ref.read(pdfGenerationProvider.notifier).generate(
          images: images,
          settings: settings,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pdfGenerationProvider);

    ref.listen(pdfGenerationProvider, (previous, next) async {
      if (next.isDone && next.result != null) {
        // Capture navigator before the await to avoid stale context
        final nav = Navigator.of(context);
        ref.read(pdfPreviewProvider.notifier).init(next.result!);
        await HapticUtils.notificationSuccess();
        nav.pushReplacement(
          CupertinoPageRoute<void>(
            builder: (_) => const PdfPreviewScreen(),
          ),
        );
      }
      if (next.hasError) {
        await HapticUtils.notificationError();
      }
    });

    return CupertinoPageScaffold(
      backgroundColor: AppColors.surfacePrimary.resolveFrom(context),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sp32),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: state.hasError
                  ? GenerationErrorView(
                      key: const ValueKey('error'),
                      message: state.error!.message,
                      onRetry: _startGeneration,
                      onCancel: () => Navigator.of(context)
                          .popUntil((r) => r.isFirst),
                    )
                  : GenerationProgress(
                      key: const ValueKey('progress'),
                      progress: state.progress,
                      currentPage: state.currentPage,
                      totalPages: state.totalPages,
                    ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 300))
        .slideY(
          begin: 0.04,
          end: 0.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
  }
}
