import 'package:pdf/pdf.dart';

enum PageSize {
  a4,
  letter,
  fitToImage;

  String get displayName => switch (this) {
        PageSize.a4 => 'A4',
        PageSize.letter => 'Letter',
        PageSize.fitToImage => 'Fit to Image',
      };

  /// Returns the PdfPageFormat for this page size.
  /// For [fitToImage], caller must provide the image dimensions in points.
  PdfPageFormat toPdfPageFormat({
    PageOrientation orientation = PageOrientation.portrait,
    double imageWidthPt = 595.28,
    double imageHeightPt = 841.89,
  }) {
    final PdfPageFormat base = switch (this) {
      PageSize.a4 => PdfPageFormat.a4,
      PageSize.letter => PdfPageFormat.letter,
      PageSize.fitToImage => PdfPageFormat(imageWidthPt, imageHeightPt),
    };

    return orientation == PageOrientation.landscape
        ? base.landscape
        : base.portrait;
  }
}

enum PageOrientation {
  portrait,
  landscape;

  String get displayName => switch (this) {
        PageOrientation.portrait => 'Portrait',
        PageOrientation.landscape => 'Landscape',
      };
}
