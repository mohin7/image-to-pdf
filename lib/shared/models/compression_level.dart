enum CompressionLevel {
  bright,
  optimized,
  robust;

  String get label => switch (this) {
        CompressionLevel.bright => 'Bright',
        CompressionLevel.optimized => 'Optimized',
        CompressionLevel.robust => 'Robust',
      };

  String get description => switch (this) {
        CompressionLevel.bright => 'Higher quality, larger file size',
        CompressionLevel.optimized => 'Ideal balance of quality and file size',
        CompressionLevel.robust => 'Smallest file size, reduced quality',
      };

  /// JPEG quality (0–100) used when re-encoding PDF page images
  int get qualityPercent => switch (this) {
        CompressionLevel.bright => 85,
        CompressionLevel.optimized => 60,
        CompressionLevel.robust => 30,
      };
}
