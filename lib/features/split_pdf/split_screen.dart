import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/components/app_bar_glass.dart';
import '../../design_system/components/dashed_upload_box.dart';
import '../../design_system/components/primary_button.dart';
import '../../design_system/tokens/app_colors.dart';
import '../../design_system/tokens/app_spacing.dart';
import '../../design_system/tokens/app_typography.dart';
import '../../services/file_picker_service.dart';
import '../../services/pdf_kit_service.dart';
import '../../shared/models/pdf_document.dart';
import 'providers/split_pdf_notifier.dart';
import 'widgets/page_chip.dart';
import 'widgets/split_result_list.dart';

class SplitScreen extends ConsumerWidget {
  const SplitScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(splitPdfProvider);
    final notifier = ref.read(splitPdfProvider.notifier);
    final pageCount = state.selectedFile?.pageCount ?? 0;
    final accent = AppColors.accentRed.resolveFrom(context);
    final primary = AppColors.labelPrimary.resolveFrom(context);
    final secondary = AppColors.labelSecondary.resolveFrom(context);

    return CupertinoPageScaffold(
      backgroundColor: AppColors.backgroundPrimary.resolveFrom(context),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: AppSpacing.sp32 + 120.0 + MediaQuery.of(context).padding.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Spacer for glass nav bar
                SizedBox(height: MediaQuery.of(context).padding.top + 44),

              // ── Hero ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.sp16, AppSpacing.sp20, AppSpacing.sp16, AppSpacing.sp4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: AppTypography.title1Bold.copyWith(color: primary),
                        children: [
                          const TextSpan(text: 'Split '),
                          TextSpan(text: 'PDF', style: TextStyle(color: accent)),
                          const TextSpan(text: ' Files Easily'),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sp8),
                    Text(
                      'Select the pages you need, then extract them into a new PDF file.',
                      style: AppTypography.subheadline.copyWith(color: secondary),
                    ),
                  ],
                ),
              ),

              // ── Upload box ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.sp16, AppSpacing.sp16, AppSpacing.sp16, 0),
                child: DashedUploadBox(
                  onTap: () => _pickFile(context, ref),
                  title: 'Tap here to choose a PDF file.',
                  isSelected: state.selectedFile != null,
                  selectedLabel: state.selectedFile != null
                      ? '${state.selectedFile!.fileName}  ·  $pageCount pages'
                      : null,
                  showChooseButton: state.selectedFile == null,
                ),
              ),

              if (state.selectedFile != null && pageCount > 0) ...[
                const SizedBox(height: AppSpacing.sp24),

                // ── Selection controls ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sp16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${state.selectedPages.length} pages selected',
                        style: AppTypography.subheadline.copyWith(
                          color: primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: notifier.selectAll,
                            child: Text(
                              'Select All',
                              style: AppTypography.footnote.copyWith(
                                color: accent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sp4),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: notifier.clearSelection,
                            child: Text(
                              'Clear',
                              style: AppTypography.footnote.copyWith(
                                color: secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sp12),

                // ── Page grid ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sp16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: AppSpacing.sp10,
                      mainAxisSpacing: AppSpacing.sp10,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: pageCount,
                    itemBuilder: (_, i) => PageChip(
                      pageNumber: i + 1,
                      isSelected: state.selectedPages.contains(i),
                      onTap: () => notifier.togglePage(i),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.sp24),

                if (state.results.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sp16),
                    child: SplitResultList(results: state.results),
                  ),
                  const SizedBox(height: AppSpacing.sp12),
                ],

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sp16),
                  child: PrimaryButton(
                    label: state.isProcessing
                        ? 'Extracting…'
                        : 'Extract ${state.selectedPages.length} Pages',
                    onPressed: state.isProcessing ||
                            state.selectedPages.isEmpty
                        ? null
                        : notifier.split,
                    isLoading: state.isProcessing,
                  ),
                ),

                if (state.error != null) ...[
                  const SizedBox(height: AppSpacing.sp12),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sp16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sp14,
                        vertical: AppSpacing.sp10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.destructive
                            .resolveFrom(context)
                            .withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.destructive
                              .resolveFrom(context)
                              .withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.exclamationmark_circle_fill,
                            color: AppColors.destructive.resolveFrom(context),
                            size: 16,
                          ),
                          const SizedBox(width: AppSpacing.sp8),
                          Expanded(
                            child: Text(
                              state.error!,
                              style: AppTypography.footnote.copyWith(
                                color: AppColors.destructive.resolveFrom(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),

          // ── Frosted glass nav bar overlay ─────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBarGlass(
              title: 'Split PDF',
              trailing: state.selectedFile != null
                  ? AppBarTrailingButton(
                      icon: CupertinoIcons.arrow_counterclockwise,
                      label: 'Reset',
                      onPressed: notifier.reset,
                      color: AppColors.destructive.resolveFrom(context),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile(BuildContext context, WidgetRef ref) async {
    final pickerService = ref.read(filePickerServiceProvider);
    final pdfKit = ref.read(pdfKitServiceProvider);
    final docs = await pickerService.pickPdfFiles(allowMultiple: false);
    if (docs.isEmpty) return;

    final raw = docs.first;
    final pageCount = await pdfKit.getPageCount(raw.filePath);
    ref.read(splitPdfProvider.notifier).setFile(PdfDocument(
          filePath: raw.filePath,
          fileName: raw.fileName,
          pageCount: pageCount,
          fileSizeBytes: raw.fileSizeBytes,
        ));
  }
}
