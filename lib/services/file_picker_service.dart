import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/models/pdf_document.dart';

class FilePickerService {
  Future<List<PdfDocument>> pickPdfFiles({bool allowMultiple = false}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: allowMultiple,
    );

    if (result == null || result.files.isEmpty) return [];

    final docs = <PdfDocument>[];
    for (final f in result.files) {
      if (f.path == null) continue;
      final file = File(f.path!);
      if (!file.existsSync()) continue;
      docs.add(PdfDocument(
        filePath: f.path!,
        fileName: f.name,
        pageCount: 0, // resolved later by PdfKitService.getPageCount
        fileSizeBytes: f.size,
      ));
    }
    return docs;
  }
}

final filePickerServiceProvider = Provider<FilePickerService>(
  (_) => FilePickerService(),
);
