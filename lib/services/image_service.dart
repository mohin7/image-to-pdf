import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  ImageService() : _picker = ImagePicker();

  final ImagePicker _picker;

  /// Opens the native iOS photo picker (PHPickerViewController) for multi-select.
  Future<List<String>> pickFromGallery({int maxImages = 30}) async {
    final images = await _picker.pickMultiImage(
      requestFullMetadata: false,
    );
    return images.map((x) => x.path).toList();
  }

  /// Opens the system camera for single photo capture.
  Future<String?> captureFromCamera() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );
    return image?.path;
  }

  /// Opens the native document scanner (VisionKit on iOS, ML Kit on Android).
  Future<List<String>> scanDocuments() async {
    try {
      final pictures = await CunningDocumentScanner.getPictures();
      return pictures ?? [];
    } catch (e) {
      // Return empty list if the user cancels or an error occurs.
      return [];
    }
  }
}

final imageServiceProvider = Provider<ImageService>(
  (ref) => ImageService(),
);
