import 'package:equatable/equatable.dart';
import 'page_size.dart';

enum ImageQuality {
  low,
  medium,
  high,
  maximum;

  String get displayName => switch (this) {
        ImageQuality.low => 'Low',
        ImageQuality.medium => 'Medium',
        ImageQuality.high => 'High',
        ImageQuality.maximum => 'Maximum',
      };

  int get percent => switch (this) {
        ImageQuality.low => 45,
        ImageQuality.medium => 65,
        ImageQuality.high => 80,
        ImageQuality.maximum => 100,
      };
}

enum PageMargin {
  none,
  small,
  normal,
  large;

  String get displayName => switch (this) {
        PageMargin.none => 'None',
        PageMargin.small => 'Small',
        PageMargin.normal => 'Normal',
        PageMargin.large => 'Large',
      };

  double get points => switch (this) {
        PageMargin.none => 0.0,
        PageMargin.small => 8.0,
        PageMargin.normal => 16.0,
        PageMargin.large => 32.0,
      };
}

class PdfSettings extends Equatable {
  const PdfSettings({
    this.pageSize = PageSize.a4,
    this.orientation = PageOrientation.portrait,
    this.quality = ImageQuality.high,
    this.margin = PageMargin.normal,
  });

  final PageSize pageSize;
  final PageOrientation orientation;
  final ImageQuality quality;
  final PageMargin margin;

  PdfSettings copyWith({
    PageSize? pageSize,
    PageOrientation? orientation,
    ImageQuality? quality,
    PageMargin? margin,
  }) {
    return PdfSettings(
      pageSize: pageSize ?? this.pageSize,
      orientation: orientation ?? this.orientation,
      quality: quality ?? this.quality,
      margin: margin ?? this.margin,
    );
  }

  @override
  List<Object?> get props => [pageSize, orientation, quality, margin];
}
