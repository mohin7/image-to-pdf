import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/utils/file_name_generator.dart';
import '../../../services/pdf_kit_service.dart';
import '../../../shared/models/compression_level.dart';
import '../../../shared/models/pdf_document.dart';
import '../../../shared/models/pdf_result.dart';

class CompressPdfState extends Equatable {
  const CompressPdfState({
    this.selectedFile,
    this.level = CompressionLevel.optimized,
    this.isProcessing = false,
    this.result,
    this.error,
  });

  final PdfDocument? selectedFile;
  final CompressionLevel level;
  final bool isProcessing;
  final PdfResult? result;
  final String? error;

  CompressPdfState copyWith({
    PdfDocument? selectedFile,
    CompressionLevel? level,
    bool? isProcessing,
    PdfResult? result,
    String? error,
    bool clearResult = false,
    bool clearError = false,
    bool clearFile = false,
  }) {
    return CompressPdfState(
      selectedFile: clearFile ? null : selectedFile ?? this.selectedFile,
      level: level ?? this.level,
      isProcessing: isProcessing ?? this.isProcessing,
      result: clearResult ? null : result ?? this.result,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props =>
      [selectedFile, level, isProcessing, result, error];
}

class CompressPdfNotifier extends Notifier<CompressPdfState> {
  @override
  CompressPdfState build() => const CompressPdfState();

  void setFile(PdfDocument doc) {
    state = state.copyWith(
      selectedFile: doc,
      clearResult: true,
      clearError: true,
    );
  }

  void setLevel(CompressionLevel level) {
    state = state.copyWith(level: level, clearResult: true);
  }

  Future<void> compress() async {
    final file = state.selectedFile;
    if (file == null) return;

    state = state.copyWith(isProcessing: true, clearResult: true, clearError: true);

    try {
      final dir = await getApplicationDocumentsDirectory();
      final outputPath = '${dir.path}/${FileNameGenerator.generatePdfName()}';

      final pdfKit = ref.read(pdfKitServiceProvider);
      final resultPath = await pdfKit.compressPdf(
        inputPath: file.filePath,
        qualityPercent: state.level.qualityPercent,
        outputPath: outputPath,
      );

      final resultFile = File(resultPath);
      final sizeBytes = await resultFile.length();

      state = state.copyWith(
        isProcessing: false,
        result: PdfResult(
          filePath: resultPath,
          pageCount: file.pageCount,
          fileSizeBytes: sizeBytes,
          generatedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: e.toString(),
      );
    }
  }

  void reset() => state = const CompressPdfState();
}

final compressPdfProvider =
    NotifierProvider<CompressPdfNotifier, CompressPdfState>(
  CompressPdfNotifier.new,
);
