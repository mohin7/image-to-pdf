import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dart-side wrapper for the native iOS PDFKit MethodChannel.
/// All heavy work runs on the native thread — no isolates needed here.
class PdfKitService {
  static const _channel = MethodChannel('com.imagetopdf/pdfkit');

  Future<int> getPageCount(String filePath) async {
    final count = await _channel.invokeMethod<int>(
      'getPageCount',
      {'path': filePath},
    );
    return count ?? 0;
  }

  Future<String> mergePdfs({
    required List<String> inputPaths,
    required String outputPath,
  }) async {
    final result = await _channel.invokeMethod<String>(
      'merge',
      {'paths': inputPaths, 'outputPath': outputPath},
    );
    return result!;
  }

  /// [pageIndexes] is 0-based. Returns the path of the extracted PDF.
  Future<String> splitPdf({
    required String inputPath,
    required List<int> pageIndexes,
    required String outputPath,
  }) async {
    final result = await _channel.invokeMethod<String>(
      'split',
      {
        'path': inputPath,
        'pages': pageIndexes,
        'outputPath': outputPath,
      },
    );
    return result!;
  }

  /// [qualityPercent] 0–100. Returns path of the compressed PDF.
  Future<String> compressPdf({
    required String inputPath,
    required int qualityPercent,
    required String outputPath,
  }) async {
    final result = await _channel.invokeMethod<String>(
      'compress',
      {
        'path': inputPath,
        'quality': qualityPercent,
        'outputPath': outputPath,
      },
    );
    return result!;
  }
}

final pdfKitServiceProvider = Provider<PdfKitService>(
  (_) => PdfKitService(),
);
