import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_error.dart';
import '../../../services/file_service.dart';
import '../../../services/pdf_service.dart';
import '../../../shared/models/image_item.dart';
import '../../../shared/models/pdf_result.dart';
import '../../../shared/models/pdf_settings.dart';

class PdfGenerationState {
  const PdfGenerationState({
    this.isLoading = false,
    this.progress = 0.0,
    this.currentPage = 0,
    this.totalPages = 0,
    this.result,
    this.error,
  });

  final bool isLoading;
  final double progress;
  final int currentPage;
  final int totalPages;
  final PdfResult? result;
  final AppError? error;

  bool get hasError => error != null;
  bool get isDone => result != null;

  PdfGenerationState copyWith({
    bool? isLoading,
    double? progress,
    int? currentPage,
    int? totalPages,
    PdfResult? result,
    AppError? error,
  }) {
    return PdfGenerationState(
      isLoading: isLoading ?? this.isLoading,
      progress: progress ?? this.progress,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      result: result ?? this.result,
      error: error ?? this.error,
    );
  }
}

class PdfGenerationNotifier extends Notifier<PdfGenerationState> {
  @override
  PdfGenerationState build() => const PdfGenerationState();

  Future<void> generate({
    required List<ImageItem> images,
    required PdfSettings settings,
  }) async {
    state = PdfGenerationState(
      isLoading: true,
      totalPages: images.length,
    );

    try {
      final pdfService = ref.read(pdfServiceProvider);
      final fileService = ref.read(fileServiceProvider);

      final bytes = await pdfService.generate(
        images: images,
        settings: settings,
        onProgress: (progress, page) {
          state = state.copyWith(progress: progress, currentPage: page);
        },
      );

      final result = await fileService.savePdf(
        bytes,
        pageCount: images.length,
      );

      state = state.copyWith(
        isLoading: false,
        progress: 1.0,
        result: result,
      );
    } on AppError catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: PdfGenerationError(e.toString()),
      );
    }
  }

  void reset() => state = const PdfGenerationState();
}

final pdfGenerationProvider =
    NotifierProvider<PdfGenerationNotifier, PdfGenerationState>(
  PdfGenerationNotifier.new,
);
