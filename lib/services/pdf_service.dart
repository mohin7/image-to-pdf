import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/widgets.dart' as pw;

import '../shared/models/image_item.dart';
import '../shared/models/pdf_settings.dart';

class PdfService {
  /// Generates a PDF from [images] respecting [settings].
  /// Calls [onProgress] after each page with current fraction (0.0–1.0) and page index.
  Future<Uint8List> generate({
    required List<ImageItem> images,
    required PdfSettings settings,
    void Function(double progress, int currentPage)? onProgress,
  }) async {
    final doc = pw.Document();

    for (int i = 0; i < images.length; i++) {
      final compressedBytes = await _compressImage(
        images[i].path,
        settings.quality.percent,
      );

      final pdfImage = pw.MemoryImage(compressedBytes);

      // Decode to get real dimensions for fitToImage page size
      final decoded = await _getImageSize(compressedBytes);
      final widthPt = decoded.$1.toDouble();
      final heightPt = decoded.$2.toDouble();

      final pageFormat = settings.pageSize.toPdfPageFormat(
        orientation: settings.orientation,
        imageWidthPt: widthPt,
        imageHeightPt: heightPt,
      );

      final marginPt = settings.margin.points;

      doc.addPage(
        pw.Page(
          pageFormat: pageFormat,
          margin: pw.EdgeInsets.all(marginPt),
          build: (_) => pw.Center(
            child: pw.Image(pdfImage, fit: pw.BoxFit.contain),
          ),
        ),
      );

      onProgress?.call((i + 1) / images.length, i + 1);
    }

    return doc.save();
  }

  /// Compresses an image to JPEG/PNG bytes.
  /// Note: dart:ui operations are already asynchronous and offloaded by the engine, 
  /// so we don't need (and cannot use) a background isolate for instantiateImageCodec.
  Future<Uint8List> _compressImage(String path, int quality) async {
    final bytes = await File(path).readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final byteData = await frame.image.toByteData(format: ui.ImageByteFormat.png);
    frame.image.dispose();
    codec.dispose();
    
    return byteData!.buffer.asUint8List();
  }

  Future<(int, int)> _getImageSize(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final w = frame.image.width;
    final h = frame.image.height;
    frame.image.dispose();
    codec.dispose();
    return (w, h);
  }
}

final pdfServiceProvider = Provider<PdfService>(
  (ref) => PdfService(),
);
