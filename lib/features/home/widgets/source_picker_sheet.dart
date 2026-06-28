import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/image_service.dart';
import '../providers/image_list_notifier.dart';

class SourcePickerSheet extends ConsumerWidget {
  const SourcePickerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoActionSheet(
      actions: [
        // Scan Document uses VisionKit/MLKit
        if (Platform.isIOS || Platform.isAndroid)
          CupertinoActionSheetAction(
            onPressed: () async {
              final service = ref.read(imageServiceProvider);
              final notifier = ref.read(imageListProvider.notifier);
              Navigator.of(context).pop();
              final paths = await service.scanDocuments();
              if (paths.isNotEmpty) notifier.addImages(paths);
            },
            child: const Text('Scan Document'),
          ),
        // Camera is only available on iOS/iPadOS/Android — not macOS
        if (Platform.isIOS || Platform.isAndroid)
          CupertinoActionSheetAction(
            onPressed: () async {
              final service = ref.read(imageServiceProvider);
              final notifier = ref.read(imageListProvider.notifier);
              Navigator.of(context).pop();
              final path = await service.captureFromCamera();
              if (path != null) notifier.addImages([path]);
            },
            child: const Text('Camera'),
          ),
        CupertinoActionSheetAction(
          onPressed: () async {
            final service = ref.read(imageServiceProvider);
            final notifier = ref.read(imageListProvider.notifier);
            Navigator.of(context).pop();
            final paths = await service.pickFromGallery();
            if (paths.isNotEmpty) notifier.addImages(paths);
          },
          child: const Text('Photo Library'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
    );
  }
}

void showSourcePicker(BuildContext context) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (_) => const SourcePickerSheet(),
  );
}
