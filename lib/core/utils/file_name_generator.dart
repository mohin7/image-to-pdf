import 'dart:io';

abstract final class FileNameGenerator {
  static const _months = [
    'january', 'february', 'march', 'april', 'may', 'june',
    'july', 'august', 'september', 'october', 'november', 'december'
  ];

  static String generatePdfName(Directory dir) {
    final now = DateTime.now();
    final count = dir.listSync().where((e) => e.path.endsWith('.pdf')).length + 1;
    
    final day = now.day;
    final month = _months[now.month - 1];
    final year = now.year;
    
    return '${count}_pdf_${day}_${month}_$year.pdf';
  }
}
