import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/pdf_result.dart';

class PdfPreviewState {
  const PdfPreviewState({
    this.result,
    this.currentPage = 1,
    this.totalPages = 1,
  });

  final PdfResult? result;
  final int currentPage;
  final int totalPages;

  PdfPreviewState copyWith({
    PdfResult? result,
    int? currentPage,
    int? totalPages,
  }) {
    return PdfPreviewState(
      result: result ?? this.result,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

class PdfPreviewNotifier extends Notifier<PdfPreviewState> {
  @override
  PdfPreviewState build() => const PdfPreviewState();

  void init(PdfResult result) {
    state = PdfPreviewState(
      result: result,
      currentPage: 1,
      totalPages: result.pageCount,
    );
  }

  void setCurrentPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void reset() => state = const PdfPreviewState();
}

final pdfPreviewProvider =
    NotifierProvider<PdfPreviewNotifier, PdfPreviewState>(
  PdfPreviewNotifier.new,
);
