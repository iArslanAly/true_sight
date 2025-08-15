import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

enum ImageType { profile, general }

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// Compress and resize image
  Future<File?> _compressAndResize(File file, ImageType type) async {
    final quality = type == ImageType.profile ? 50 : 90;
    final maxWidth = type == ImageType.profile ? 600 : 1920;
    final maxHeight = type == ImageType.profile ? 600 : 1920;

    final targetPath =
        '${file.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      minWidth: maxWidth,
      minHeight: maxHeight,
      format: CompressFormat.jpeg,
    );

    return result != null ? File(result.path) : null;
  }

  Future<File?> pickFromGallery({ImageType type = ImageType.general}) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;
    return _compressAndResize(File(pickedFile.path), type);
  }

  Future<File?> pickFromCamera({ImageType type = ImageType.general}) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return null;
    return _compressAndResize(File(pickedFile.path), type);
  }
}
