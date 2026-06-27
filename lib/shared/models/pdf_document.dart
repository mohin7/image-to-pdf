import 'package:equatable/equatable.dart';

class PdfDocument extends Equatable {
  const PdfDocument({
    required this.filePath,
    required this.fileName,
    required this.pageCount,
    required this.fileSizeBytes,
  });

  final String filePath;
  final String fileName;
  final int pageCount;
  final int fileSizeBytes;

  String get fileSizeDisplay {
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(2)} KB';
    }
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  @override
  List<Object?> get props => [filePath];
}
