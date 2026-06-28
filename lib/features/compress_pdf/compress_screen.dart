import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../design_system/components/app_bar_glass.dart';
import '../../design_system/components/dashed_upload_box.dart';
import '../../design_system/components/flat_card.dart';
import '../../design_system/components/primary_button.dart';
import '../../design_system/tokens/app_colors.dart';
import '../../design_system/tokens/app_spacing.dart';
import '../../design_system/tokens/app_typography.dart';
import '../../services/file_picker_service.dart';
import '../../services/pdf_kit_service.dart';
import '../../shared/models/compression_level.dart';
import '../../shared/models/pdf_document.dart';
import 'providers/compress_pdf_notifier.dart';
import 'widgets/compression_option_card.dart';
import 'widgets/file_size_result_row.dart';

class CompressScreen extends ConsumerWidget {
  const CompressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(compressPdfProvider);
    final notifier = ref.read(compressPdfProvider.notifier);
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

              // ── Hero ──────────────────────────────────────────────────────
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
                          const TextSpan(text: 'Shrink your '),
                          TextSpan(text: 'PDF', style: TextStyle(color: accent)),
                          const TextSpan(text: ' file.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sp8),
                    Text(
                      'Reduce file size while preserving quality — no uploads needed.',
                      style: AppTypography.subheadline.copyWith(color: secondary),
                    ),
                  ],
                ),
              ),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sp16),
                child: DashedUploadBox(
                  onTap: () => _pickFile(context, ref),
                  title: 'Tap or click here to choose a PDF file.',
                  subtitle: 'No file size limit.',
                  isSelected: state.selectedFile != null,
                  selectedLabel: state.selectedFile?.fileName,
                ),
              ),

              if (state.selectedFile != null) ...[
                // ── Selected file card ────────────────────────────────────
                const SizedBox(height: AppSpacing.sp12),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.sp16),
                  child: FlatCard(
                    padding: const EdgeInsets.all(AppSpacing.sp16),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            CupertinoIcons.doc_fill,
                            color: accent,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sp12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.selectedFile!.fileName,
                                style: AppTypography.subheadline
                                    .copyWith(color: primary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Current File Size: ${state.selectedFile!.fileSizeDisplay}',
                                style: AppTypography.caption1.copyWith(
                                    color: AppColors.labelSecondary
                                        .resolveFrom(context)),
                              ),
                            ],
                          ),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: notifier.reset,
                          child: Icon(
                            CupertinoIcons.xmark_circle_fill,
                            color: AppColors.labelTertiary.resolveFrom(context),
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Compression level ────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.sp16, AppSpacing.sp24, AppSpacing.sp16, AppSpacing.sp10),
                  child: Text(
                    'Compression Level',
                    style: AppTypography.subheadline.copyWith(
                      color: primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                ...CompressionLevel.values.map((level) => Padding(
                      padding: const EdgeInsets.fromLTRB(
                          AppSpacing.sp16, 0, AppSpacing.sp16, AppSpacing.sp8),
                      child: CompressionOptionCard(
                        level: level,
                        isSelected: state.level == level,
                        onTap: () => notifier.setLevel(level),
                      ),
                    )),

                // ── Result ──────────────────────────────────────────────
                if (state.result != null) ...[
                  const SizedBox(height: AppSpacing.sp8),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sp16),
                    child: FileSizeResultRow(
                      original: state.selectedFile!,
                      compressed: state.result!,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sp12),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sp16),
                    child: Builder(
                      builder: (btnCtx) => PrimaryButton(
                        label: 'Share Compressed PDF',
                        icon: CupertinoIcons.share,
                        onPressed: () {
                          final box = btnCtx.findRenderObject() as RenderBox?;
                          final origin = box != null
                              ? box.localToGlobal(Offset.zero) & box.size
                              : Rect.largest;
                          Share.shareXFiles(
                            [
                              XFile(state.result!.filePath,
                                  mimeType: 'application/pdf')
                            ],
                            subject: state.result!.fileName,
                            sharePositionOrigin: origin,
                          );
                        },
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: AppSpacing.sp16),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sp16),
                    child: PrimaryButton(
                      label: state.isProcessing ? 'Compressing…' : 'Compress Now',
                      onPressed: state.isProcessing ? null : notifier.compress,
                      isLoading: state.isProcessing,
                    ),
                  ),
                ],

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
            child: const AppBarGlass(title: 'Compress PDF'),
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
    final doc = PdfDocument(
      filePath: raw.filePath,
      fileName: raw.fileName,
      pageCount: pageCount,
      fileSizeBytes: raw.fileSizeBytes,
    );
    ref.read(compressPdfProvider.notifier).setFile(doc);
  }
}
