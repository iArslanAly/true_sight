import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:true_sight/core/cubits/permission_cubit.dart';
import 'package:true_sight/core/utils/image_picker.dart';
import 'package:true_sight/core/widgets/custom_dialog.dart';

enum ImageSourceType { camera, gallery }

class ImagePickerHelper {
  /// Global function to pick image with permission handling
  static Future<File?> pickImageWithPermission(
    BuildContext context, {
    required ImageSourceType sourceType,
    required ImageType imageType,
    required Function(File file) onFilePicked,
  }) async {
    final permissionCubit = context.read<PermissionCubit>();

    // Determine correct permission
    Permission permission;
    if (Platform.isIOS) {
      permission = sourceType == ImageSourceType.camera
          ? Permission.camera
          : Permission.photos;
    } else {
      permission = sourceType == ImageSourceType.camera
          ? Permission.camera
          : Permission.storage;
    }

    // Request permission
    await permissionCubit.requestPermission(permission);

    final result = await permissionCubit.stream.firstWhere(
      (state) =>
          state is PermissionGranted ||
          state is PermissionDenied ||
          state is PermissionSuggestSettings,
    );

    if (result is PermissionGranted) {
      final picker = ImagePickerService();
      final file = sourceType == ImageSourceType.camera
          ? await picker.pickFromCamera(type: imageType)
          : await picker.pickFromGallery(type: imageType);

      if (file != null) {
        onFilePicked(file);
        return file;
      }
    } else if (result is PermissionSuggestSettings) {
      final openSettings = await showDialog<bool>(
        context: context,
        builder: (ctx) => CustomDialog(
          title: 'Permission Required',
          content:
              'You have permanently denied this permission. Please enable it in app settings.',
          cancelText: 'Cancel',
          confirmText: 'Open Settings',
          onConfirm: () => openAppSettings(),
        ),
      );
      if (openSettings == true) openAppSettings();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Permission denied")));
    }
    return null;
  }
}
