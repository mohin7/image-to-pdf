import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../shared/models/image_item.dart';

class ImageListNotifier extends Notifier<List<ImageItem>> {
  static const _uuid = Uuid();

  @override
  List<ImageItem> build() => [];

  void addImages(List<String> paths) {
    final newItems = paths.map(
      (path) => ImageItem(
        id: _uuid.v4(),
        path: path,
        addedAt: DateTime.now(),
      ),
    );
    state = [...state, ...newItems];
  }

  void removeImage(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void reorderImages(int oldIndex, int newIndex) {
    final list = [...state];
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    state = list;
  }

  void clearAll() {
    state = [];
  }
}

final imageListProvider =
    NotifierProvider<ImageListNotifier, List<ImageItem>>(
  ImageListNotifier.new,
);

final canConvertProvider = Provider<bool>(
  (ref) => ref.watch(imageListProvider).isNotEmpty,
);

final imageCountProvider = Provider<int>(
  (ref) => ref.watch(imageListProvider).length,
);
