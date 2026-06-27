import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/pdf_settings.dart';
import '../../../shared/models/page_size.dart';

class PdfSettingsNotifier extends Notifier<PdfSettings> {
  @override
  PdfSettings build() => const PdfSettings();

  void setPageSize(PageSize value) =>
      state = state.copyWith(pageSize: value);

  void setOrientation(PageOrientation value) =>
      state = state.copyWith(orientation: value);

  void setQuality(ImageQuality value) =>
      state = state.copyWith(quality: value);

  void setMargin(PageMargin value) =>
      state = state.copyWith(margin: value);

  void reset() => state = const PdfSettings();
}

final pdfSettingsProvider =
    NotifierProvider<PdfSettingsNotifier, PdfSettings>(
  PdfSettingsNotifier.new,
);
