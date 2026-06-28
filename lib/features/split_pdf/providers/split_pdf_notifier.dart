import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/utils/file_name_generator.dart';
import '../../../services/pdf_kit_service.dart';
import '../../../shared/models/pdf_document.dart';
import '../../../shared/models/pdf_result.dart';

class SplitPdfState extends Equatable {
  const SplitPdfState({
    this.selectedFile,
    this.selectedPages = const {},
    this.isProcessing = false,
    this.results = const [],
    this.error,
  });

  final PdfDocument? selectedFile;
  final Set<int> selectedPages; // 0-based page indexes
  final bool isProcessing;
  final List<PdfResult> results;
  final String? error;

  SplitPdfState copyWith({
    PdfDocument? selectedFile,
    Set<int>? selectedPages,
    bool? isProcessing,
    List<PdfResult>? results,
    String? error,
    bool clearFile = false,
    bool clearResults = false,
    bool clearError = false,
  }) {
    return SplitPdfState(
      selectedFile: clearFile ? null : selectedFile ?? this.selectedFile,
      selectedPages: selectedPages ?? this.selectedPages,
      isProcessing: isProcessing ?? this.isProcessing,
      results: clearResults ? [] : results ?? this.results,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props =>
      [selectedFile, selectedPages, isProcessing, results, error];
}

class SplitPdfNotifier extends Notifier<SplitPdfState> {
  @override
  SplitPdfState build() => const SplitPdfState();

  void setFile(PdfDocument doc) {
    state = SplitPdfState(selectedFile: doc);
  }

  void togglePage(int pageIndex) {
    final pages = Set<int>.from(state.selectedPages);
    if (pages.contains(pageIndex)) {
      pages.remove(pageIndex);
    } else {
      pages.add(pageIndex);
    }
    state = state.copyWith(selectedPages: pages, clearResults: true);
  }

  void selectAll() {
    if (state.selectedFile == null) return;
    state = state.copyWith(
      selectedPages: Set.from(
        List.generate(state.selectedFile!.pageCount, (i) => i),
      ),
    );
  }

  void clearSelection() {
    state = state.copyWith(selectedPages: {}, clearResults: true);
  }

  Future<void> split() async {
    final file = state.selectedFile;
    if (file == null || state.selectedPages.isEmpty) return;

    state = state.copyWith(
        isProcessing: true, clearResults: true, clearError: true);

    try {
      final dir = await getApplicationDocumentsDirectory();
      final outputPath =
          '${dir.path}/${FileNameGenerator.generatePdfName(dir)}';

      final pdfKit = ref.read(pdfKitServiceProvider);
      final resultPath = await pdfKit.splitPdf(
        inputPath: file.filePath,
        pageIndexes: state.selectedPages.toList()..sort(),
        outputPath: outputPath,
      );

      final resultFile = File(resultPath);
      final sizeBytes = await resultFile.length();

      state = state.copyWith(
        isProcessing: false,
        results: [
          PdfResult(
            filePath: resultPath,
            pageCount: state.selectedPages.length,
            fileSizeBytes: sizeBytes,
            generatedAt: DateTime.now(),
          ),
        ],
      );
    } catch (e) {
      state = state.copyWith(isProcessing: false, error: e.toString());
    }
  }

  void reset() => state = const SplitPdfState();
}

final splitPdfProvider =
    NotifierProvider<SplitPdfNotifier, SplitPdfState>(
  SplitPdfNotifier.new,
);
