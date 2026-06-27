import 'package:equatable/equatable.dart';

class PdfResult extends Equatable {
  const PdfResult({
    required this.filePath,
    required this.pageCount,
    required this.fileSizeBytes,
    required this.generatedAt,
  });

  final String filePath;
  final int pageCount;
  final int fileSizeBytes;
  final DateTime generatedAt;

  String get fileName => filePath.split('/').last;

  String get fileSizeDisplay {
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  List<Object?> get props => [filePath];
}
