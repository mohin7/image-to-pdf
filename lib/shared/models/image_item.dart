import 'package:equatable/equatable.dart';

class ImageItem extends Equatable {
  const ImageItem({
    required this.id,
    required this.path,
    required this.addedAt,
  });

  final String id;
  final String path;
  final DateTime addedAt;

  ImageItem copyWith({String? id, String? path, DateTime? addedAt}) {
    return ImageItem(
      id: id ?? this.id,
      path: path ?? this.path,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  // Identity-based equality — two items with the same id are the same image
  @override
  List<Object?> get props => [id];
}
