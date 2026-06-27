import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../../../design_system/tokens/app_spacing.dart';
import '../providers/image_list_notifier.dart';
import 'image_grid_item.dart';

class ImageGrid extends ConsumerStatefulWidget {
  const ImageGrid({super.key, required this.bottomInset});

  final double bottomInset;

  @override
  ConsumerState<ImageGrid> createState() => _ImageGridState();
}

class _ImageGridState extends ConsumerState<ImageGrid> {
  String? _draggingId;

  @override
  Widget build(BuildContext context) {
    final images = ref.watch(imageListProvider);
    final notifier = ref.read(imageListProvider.notifier);

    return ReorderableGridView.builder(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.sp16,
        AppSpacing.sp16,
        AppSpacing.sp16,
        widget.bottomInset + AppSpacing.sp16,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.gridGap,
        mainAxisSpacing: AppSpacing.gridGap,
        childAspectRatio: 1.0,
      ),
      itemCount: images.length,
      onReorder: (oldIndex, newIndex) {
        HapticFeedback.selectionClick();
        notifier.reorderImages(oldIndex, newIndex);
        setState(() => _draggingId = null);
      },
      onDragStart: (index) {
        HapticFeedback.mediumImpact();
        setState(() => _draggingId = images[index].id);
      },
      itemBuilder: (context, index) {
        final item = images[index];
        return ImageGridItem(
          key: ValueKey(item.id),
          item: item,
          index: index,
          isDragging: _draggingId == item.id,
          onRemove: () => notifier.removeImage(item.id),
        );
      },
    );
  }
}
