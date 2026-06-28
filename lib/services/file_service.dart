import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../core/utils/file_name_generator.dart';
import '../shared/models/pdf_result.dart';

class FileService {
  /// Saves PDF bytes to the app's Documents directory and returns a [PdfResult].
  Future<PdfResult> savePdf(Uint8List bytes, {int pageCount = 0}) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = FileNameGenerator.generatePdfName(dir);
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);

    return PdfResult(
      filePath: file.path,
      pageCount: pageCount,
      fileSizeBytes: bytes.length,
      generatedAt: DateTime.now(),
    );
  }

  /// Opens the iOS native share sheet for the given PDF result.
  Future<void> shareFile(PdfResult result, {ui.Rect? sharePositionOrigin}) async {
    await Share.shareXFiles(
      [XFile(result.filePath, mimeType: 'application/pdf')],
      subject: result.fileName,
      sharePositionOrigin: sharePositionOrigin ?? const ui.Rect.fromLTWH(0, 0, 1, 1),
    );
  }

  /// Triggers the native save-to-files dialog.
  Future<void> saveToFiles(PdfResult result, {ui.Rect? sharePositionOrigin}) async {
    final bytes = await File(result.filePath).readAsBytes();
    await FilePicker.platform.saveFile(
      dialogTitle: 'Save PDF',
      fileName: result.fileName,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      bytes: bytes,
    );
  }

  /// Deletes a previously generated PDF from the Documents directory.
  Future<void> deletePdf(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) await file.delete();
  }
}

final fileServiceProvider = Provider<FileService>(
  (ref) => FileService(),
);
