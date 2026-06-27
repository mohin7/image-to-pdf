import 'package:flutter/services.dart';

abstract final class HapticUtils {
  static const _channel = MethodChannel('com.imagetopdf/haptics');

  static Future<void> notificationSuccess() async {
    try {
      await _channel.invokeMethod<void>('success');
    } catch (_) {
      // Graceful fallback on non-iOS platforms
      await HapticFeedback.mediumImpact();
    }
  }

  static Future<void> notificationError() async {
    try {
      await _channel.invokeMethod<void>('error');
    } catch (_) {
      await HapticFeedback.heavyImpact();
    }
  }

  static Future<void> notificationWarning() async {
    try {
      await _channel.invokeMethod<void>('warning');
    } catch (_) {
      await HapticFeedback.mediumImpact();
    }
  }

  static Future<void> selection() => HapticFeedback.selectionClick();
  static Future<void> light() => HapticFeedback.lightImpact();
  static Future<void> medium() => HapticFeedback.mediumImpact();
  static Future<void> heavy() => HapticFeedback.heavyImpact();
}
