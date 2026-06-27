import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/models/compression_level.dart';
import '../models/app_settings.dart';

/// Provided in main() after SharedPreferences.getInstance() resolves.
final prefsProvider = Provider<SharedPreferences>(
  (_) => throw UnimplementedError('prefsProvider must be overridden in main()'),
);

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<AppSettings> {
  static const _kUsername = 'settings_username';
  static const _kThemeMode = 'settings_themeMode';
  static const _kFontSize = 'settings_fontSize';
  static const _kPageSize = 'settings_defaultPageSize';
  static const _kCompression = 'settings_defaultCompression';
  static const _kAutoSave = 'settings_autoSavePdfs';
  static const _kHaptic = 'settings_hapticFeedback';

  SharedPreferences get _prefs => ref.read(prefsProvider);

  @override
  AppSettings build() {
    final p = _prefs;
    return AppSettings(
      username: p.getString(_kUsername) ?? '',
      themeMode: AppThemeMode
          .values[p.getInt(_kThemeMode) ?? AppThemeMode.light.index],
      fontSize:
          AppFontSize.values[p.getInt(_kFontSize) ?? AppFontSize.regular.index],
      defaultPageSize: DefaultPageSize
          .values[p.getInt(_kPageSize) ?? DefaultPageSize.a4.index],
      defaultCompression: CompressionLevel
          .values[p.getInt(_kCompression) ?? CompressionLevel.optimized.index],
      autoSavePdfs: p.getBool(_kAutoSave) ?? true,
      hapticFeedback: p.getBool(_kHaptic) ?? true,
    );
  }

  Future<void> _persist() async {
    final p = _prefs;
    await p.setString(_kUsername, state.username);
    await p.setInt(_kThemeMode, state.themeMode.index);
    await p.setInt(_kFontSize, state.fontSize.index);
    await p.setInt(_kPageSize, state.defaultPageSize.index);
    await p.setInt(_kCompression, state.defaultCompression.index);
    await p.setBool(_kAutoSave, state.autoSavePdfs);
    await p.setBool(_kHaptic, state.hapticFeedback);
  }

  void setUsername(String v) { state = state.copyWith(username: v); _persist(); }
  void setThemeMode(AppThemeMode v) { state = state.copyWith(themeMode: v); _persist(); }
  void setFontSize(AppFontSize v) { state = state.copyWith(fontSize: v); _persist(); }
  void setDefaultPageSize(DefaultPageSize v) { state = state.copyWith(defaultPageSize: v); _persist(); }
  void setDefaultCompression(CompressionLevel v) { state = state.copyWith(defaultCompression: v); _persist(); }
  void setAutoSavePdfs(bool v) { state = state.copyWith(autoSavePdfs: v); _persist(); }
  void setHapticFeedback(bool v) { state = state.copyWith(hapticFeedback: v); _persist(); }
}
