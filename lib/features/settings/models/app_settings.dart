import 'package:equatable/equatable.dart';

import '../../../shared/models/compression_level.dart';

enum AppThemeMode {
  system,
  light,
  dark;

  String get label => switch (this) {
        AppThemeMode.system => 'System',
        AppThemeMode.light => 'Light',
        AppThemeMode.dark => 'Dark',
      };
}

enum AppFontSize {
  small,
  regular,
  large;

  String get label => switch (this) {
        AppFontSize.small => 'Small',
        AppFontSize.regular => 'Regular',
        AppFontSize.large => 'Large',
      };

  double get scale => switch (this) {
        AppFontSize.small => 0.88,
        AppFontSize.regular => 1.0,
        AppFontSize.large => 1.14,
      };
}

enum DefaultPageSize {
  a4,
  letter,
  legal;

  String get label => switch (this) {
        DefaultPageSize.a4 => 'A4',
        DefaultPageSize.letter => 'Letter',
        DefaultPageSize.legal => 'Legal',
      };
}

class AppSettings extends Equatable {
  const AppSettings({
    this.username = '',
    this.themeMode = AppThemeMode.light,
    this.fontSize = AppFontSize.regular,
    this.defaultPageSize = DefaultPageSize.a4,
    this.defaultCompression = CompressionLevel.optimized,
    this.autoSavePdfs = true,
    this.hapticFeedback = true,
  });

  final String username;
  final AppThemeMode themeMode;
  final AppFontSize fontSize;
  final DefaultPageSize defaultPageSize;
  final CompressionLevel defaultCompression;
  final bool autoSavePdfs;
  final bool hapticFeedback;

  double get fontScale => fontSize.scale;

  AppSettings copyWith({
    String? username,
    AppThemeMode? themeMode,
    AppFontSize? fontSize,
    DefaultPageSize? defaultPageSize,
    CompressionLevel? defaultCompression,
    bool? autoSavePdfs,
    bool? hapticFeedback,
  }) =>
      AppSettings(
        username: username ?? this.username,
        themeMode: themeMode ?? this.themeMode,
        fontSize: fontSize ?? this.fontSize,
        defaultPageSize: defaultPageSize ?? this.defaultPageSize,
        defaultCompression: defaultCompression ?? this.defaultCompression,
        autoSavePdfs: autoSavePdfs ?? this.autoSavePdfs,
        hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      );

  @override
  List<Object?> get props => [
        username,
        themeMode,
        fontSize,
        defaultPageSize,
        defaultCompression,
        autoSavePdfs,
        hapticFeedback,
      ];
}
