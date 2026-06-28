import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/utils/file_name_generator.dart';
import '../../../services/pdf_kit_service.dart';
import '../../../shared/models/pdf_document.dart';
import '../../../shared/models/pdf_result.dart';

class MergePdfState extends Equatable {
  const MergePdfState({
    this.selectedFiles = const [],
    this.isProcessing = false,
    this.result,
    this.error,
  });

  final List<PdfDocument> selectedFiles;
  final bool isProcessing;
  final PdfResult? result;
  final String? error;

  int get totalPages =>
      selectedFiles.fold(0, (sum, f) => sum + f.pageCount);

  MergePdfState copyWith({
    List<PdfDocument>? selectedFiles,
    bool? isProcessing,
    PdfResult? result,
    String? error,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return MergePdfState(
      selectedFiles: selectedFiles ?? this.selectedFiles,
      isProcessing: isProcessing ?? this.isProcessing,
      result: clearResult ? null : result ?? this.result,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [selectedFiles, isProcessing, result, error];
}

class MergePdfNotifier extends Notifier<MergePdfState> {
  @override
  MergePdfState build() => const MergePdfState();

  void addFiles(List<PdfDocument> docs) {
    final existing = state.selectedFiles.map((f) => f.filePath).toSet();
    final newDocs = docs.where((d) => !existing.contains(d.filePath)).toList();
    state = state.copyWith(
      selectedFiles: [...state.selectedFiles, ...newDocs],
      clearResult: true,
      clearError: true,
    );
  }

  void removeFile(PdfDocument doc) {
    state = state.copyWith(
      selectedFiles:
          state.selectedFiles.where((f) => f.filePath != doc.filePath).toList(),
      clearResult: true,
    );
  }

  void reorderFiles(int oldIndex, int newIndex) {
    final list = List<PdfDocument>.from(state.selectedFiles);
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    state = state.copyWith(selectedFiles: list);
  }

  Future<void> merge() async {
    if (state.selectedFiles.length < 2) return;

    state = state.copyWith(
        isProcessing: true, clearResult: true, clearError: true);

    try {
      final dir = await getApplicationDocumentsDirectory();
      final outputPath =
          '${dir.path}/${FileNameGenerator.generatePdfName(dir)}';

      final pdfKit = ref.read(pdfKitServiceProvider);
      final resultPath = await pdfKit.mergePdfs(
        inputPaths: state.selectedFiles.map((f) => f.filePath).toList(),
        outputPath: outputPath,
      );

      final resultFile = File(resultPath);
      final sizeBytes = await resultFile.length();

      state = state.copyWith(
        isProcessing: false,
        result: PdfResult(
          filePath: resultPath,
          pageCount: state.totalPages,
          fileSizeBytes: sizeBytes,
          generatedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      state = state.copyWith(isProcessing: false, error: e.toString());
    }
  }

  void reset() => state = const MergePdfState();
}

final mergePdfProvider =
    NotifierProvider<MergePdfNotifier, MergePdfState>(
  MergePdfNotifier.new,
);
