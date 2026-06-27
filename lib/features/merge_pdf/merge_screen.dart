import 'dart:ui';

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
import 'merge_result_screen.dart';
import 'providers/merge_pdf_notifier.dart';
import 'widgets/pdf_file_list_item.dart';

class MergeScreen extends ConsumerWidget {
  const MergeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mergePdfProvider);
    final notifier = ref.read(mergePdfProvider.notifier);
    final hasFiles = state.selectedFiles.isNotEmpty;
    final accent = AppColors.accentRed.resolveFrom(context);
    final primary = AppColors.labelPrimary.resolveFrom(context);
    final secondary = AppColors.labelSecondary.resolveFrom(context);

    return CupertinoPageScaffold(
      backgroundColor: AppColors.backgroundPrimary.resolveFrom(context),
      child: Stack(
        children: [
          // ── Scrollable content ─────────────────────────────────────────
          Column(
            children: [
              // Spacer so content starts below the glass nav bar
              SizedBox(height: MediaQuery.of(context).padding.top + 44),

              Expanded(
                child: CustomScrollView(
                  slivers: [
                    // ── Hero ──────────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            AppSpacing.sp16, AppSpacing.sp20,
                            AppSpacing.sp16, AppSpacing.sp4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                style: AppTypography.title1Bold
                                    .copyWith(color: primary),
                                children: [
                                  const TextSpan(text: 'Combine '),
                                  TextSpan(
                                      text: 'PDF',
                                      style: TextStyle(color: accent)),
                                  const TextSpan(text: ' Files.'),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sp8),
                            Text(
                              'Merge multiple PDFs into one — no upload, no cloud.',
                              style: AppTypography.subheadline
                                  .copyWith(color: secondary),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Upload box ────────────────────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            AppSpacing.sp16, AppSpacing.sp16,
                            AppSpacing.sp16, 0),
                        child: DashedUploadBox(
                          onTap: () => _addFiles(context, ref),
                          title: 'Tap here to add PDF files.',
                          icon: CupertinoIcons.doc_on_doc_fill,
                          showChooseButton: !hasFiles,
                        ),
                      ),
                    ),

                    if (hasFiles) ...[
                      // ── Summary row ──────────────────────────────────
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                              AppSpacing.sp16, AppSpacing.sp16,
                              AppSpacing.sp16, AppSpacing.sp6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${state.selectedFiles.length} Files Added',
                                style: AppTypography.footnoteMedium.copyWith(
                                  color: primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (state.totalPages > 0)
                                Text(
                                  '${state.totalPages} Pages Total',
                                  style: AppTypography.footnote
                                      .copyWith(color: secondary),
                                ),
                            ],
                          ),
                        ),
                      ),

                      // ── Reorderable file list ────────────────────────
                      SliverReorderableList(
                        itemCount: state.selectedFiles.length,
                        onReorderItem: notifier.reorderFiles,
                        itemBuilder: (ctx, i) {
                          final doc = state.selectedFiles[i];
                          return ReorderableDragStartListener(
                            key: ValueKey(doc.filePath),
                            index: i,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  AppSpacing.sp16, 0,
                                  AppSpacing.sp16, AppSpacing.sp8),
                              child: PdfFileListItem(
                                doc: doc,
                                onRemove: () => notifier.removeFile(doc),
                              ),
                            ),
                          );
                        },
                      ),

                      // ── Add More Files ──────────────────────────────
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                              AppSpacing.sp16, AppSpacing.sp4,
                              AppSpacing.sp16, AppSpacing.sp16),
                          child: PrimaryButton(
                            label: 'Add More Files',
                            icon: CupertinoIcons.plus,
                            variant: PrimaryButtonVariant.outline,
                            onPressed: () => _addFiles(context, ref),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // ── Bottom CTA ─────────────────────────────────────────────
              if (state.selectedFiles.length >= 2)
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.sp16,
                        AppSpacing.sp16,
                        AppSpacing.sp16,
                        AppSpacing.sp16 +
                            MediaQuery.of(context).padding.bottom,
                      ),
                      decoration: BoxDecoration(
                        color:
                            AppColors.glassBarBackground.resolveFrom(context),
                        border: Border(
                          top: BorderSide(
                            color: AppColors.separator
                                .resolveFrom(context)
                                .withValues(alpha: 0.6),
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: PrimaryButton(
                        label: state.isProcessing
                            ? 'Merging…'
                            : 'Merge ${state.selectedFiles.length} PDFs',
                        onPressed: state.isProcessing
                            ? null
                            : () => _merge(context, ref),
                        isLoading: state.isProcessing,
                      ),
                    ),
                  ),
                ),

              if (state.error != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.sp16, 0, AppSpacing.sp16, AppSpacing.sp12,
                  ),
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
                              color:
                                  AppColors.destructive.resolveFrom(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // ── Frosted glass nav bar overlay ─────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBarGlass(
              title: 'Combine PDFs',
              trailing: hasFiles
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

  Future<void> _addFiles(BuildContext context, WidgetRef ref) async {
    final pickerService = ref.read(filePickerServiceProvider);
    final pdfKit = ref.read(pdfKitServiceProvider);
    final docs = await pickerService.pickPdfFiles(allowMultiple: true);
    if (docs.isEmpty) return;

    final resolved = <PdfDocument>[];
    for (final raw in docs) {
      final pageCount = await pdfKit.getPageCount(raw.filePath);
      resolved.add(PdfDocument(
        filePath: raw.filePath,
        fileName: raw.fileName,
        pageCount: pageCount,
        fileSizeBytes: raw.fileSizeBytes,
      ));
    }
    ref.read(mergePdfProvider.notifier).addFiles(resolved);
  }

  Future<void> _merge(BuildContext context, WidgetRef ref) async {
    await ref.read(mergePdfProvider.notifier).merge();
    final result = ref.read(mergePdfProvider).result;
    if (result == null || !context.mounted) return;

    final mergedCount = ref.read(mergePdfProvider).selectedFiles.length;
    Navigator.of(context).push(
      CupertinoPageRoute<void>(
        builder: (_) => MergeResultScreen(
          result: result,
          mergedCount: mergedCount,
        ),
      ),
    );
  }
}
