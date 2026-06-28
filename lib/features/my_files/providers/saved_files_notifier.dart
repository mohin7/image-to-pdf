import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../shared/models/pdf_result.dart';

class SavedFilesNotifier extends Notifier<List<PdfResult>> {
  @override
  List<PdfResult> build() => [];

  Future<void> load() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.pdf'))
        .toList()
      ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));

    state = files.map((f) {
      final stat = f.statSync();
      return PdfResult(
        filePath: f.path,
        pageCount: 0,
        fileSizeBytes: stat.size,
        generatedAt: stat.modified,
      );
    }).toList();
  }

  Future<void> delete(PdfResult result) async {
    final file = File(result.filePath);
    if (await file.exists()) await file.delete();
    state = state.where((r) => r.filePath != result.filePath).toList();
  }

  Future<void> rename(PdfResult result, String newName) async {
    final file = File(result.filePath);
    if (!await file.exists()) return;

    var finalName = newName.trim();
    if (finalName.isEmpty) return;
    if (!finalName.toLowerCase().endsWith('.pdf')) {
      finalName += '.pdf';
    }

    final newPath = '${file.parent.path}/$finalName';
    await file.rename(newPath);
    await load();
  }
}

final savedFilesProvider =
    NotifierProvider<SavedFilesNotifier, List<PdfResult>>(
  SavedFilesNotifier.new,
);
