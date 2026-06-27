import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../design_system/tokens/app_colors.dart';
import '../providers/pdf_preview_notifier.dart';

class PdfViewerWidget extends ConsumerWidget {
  const PdfViewerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(pdfPreviewProvider).result;

    if (result == null) {
      return const Center(child: CupertinoActivityIndicator());
    }

    return PdfPreview(
      build: (_) => File(result.filePath).readAsBytes(),
      allowPrinting: false,
      allowSharing: false,
      canChangePageFormat: false,
      canChangeOrientation: false,
      canDebug: false,
      scrollViewDecoration: BoxDecoration(
        color: AppColors.surfacePrimary.resolveFrom(context),
      ),
      pdfPreviewPageDecoration: BoxDecoration(
        color: CupertinoColors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
    );
  }
}
