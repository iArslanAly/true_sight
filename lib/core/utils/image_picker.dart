import 'dart:io';
import 'package:image_picker/image_picker.dart';

/// A service class to pick images from gallery or camera
class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from the gallery
  Future<File?> pickFromGallery({int imageQuality = 80}) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  /// Pick an image from the camera
  Future<File?> pickFromCamera({int imageQuality = 80}) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: imageQuality,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  /// Unified method to pick image (choose source dynamically)
  Future<File?> pickImage({
    required ImageSource source,
    int imageQuality = 80,
  }) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: imageQuality,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }
}
