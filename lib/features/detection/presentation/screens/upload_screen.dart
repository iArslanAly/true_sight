import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:true_sight/core/cubits/permission_cubit.dart';
import 'package:true_sight/core/utils/image_picker.dart';
import 'package:true_sight/core/utils/status/api_status.dart';

import 'package:true_sight/core/widgets/appbar.dart';
import 'package:true_sight/core/widgets/custom_dialog.dart';
import 'package:true_sight/core/widgets/image_picker_helper.dart';

import 'package:true_sight/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:true_sight/features/detection/presentation/bloc/detection_bloc.dart';
// … all of your imports stay the same …

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  Future<void> _pickImage(BuildContext context, ImageSourceType type) async {
    final permissionCubit = context.read<PermissionCubit>();

    Permission permission;
    if (Platform.isIOS) {
      permission = type == ImageSourceType.camera
          ? Permission.camera
          : Permission.photos;
    } else {
      permission = type == ImageSourceType.camera
          ? Permission.camera
          : Permission.photos;
    }

    await permissionCubit.requestPermission(permission);

    final result = await permissionCubit.stream.firstWhere(
      (state) =>
          state is PermissionGranted ||
          state is PermissionDenied ||
          state is PermissionSuggestSettings,
    );

    if (result is PermissionGranted) {
      final picker = ImagePickerService();
      final file = type == ImageSourceType.camera
          ? await picker.pickFromCamera(type: ImageType.profile)
          : await picker.pickFromGallery(type: ImageType.profile);

      if (file != null) {
        context.read<DetectionBloc>().add(StartDetectionEvent(file));
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
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ImageSourceType.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ImageSourceType.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<DetectionBloc, DetectionState>(
      listener: (context, state) {
        final status = state.status;

        if (status is ApiFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(status.errorMessage)));
        }

        if (status is ApiSuccess) {
          // Automatic navigation when upload succeeds
          context.push('/result');
        }
      },
      builder: (context, state) {
        final progress = state.uploadProgress;

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) => TopAppBar(
                name: authState.user?.name ?? 'User',
                avatarUrl: authState.user?.photoUrl,
                unreadNotifications: 3,
                onBack: () => Navigator.pop(context),
                onHistory: () => context.push('/history'),
                onNotifications: () =>
                    Navigator.pushNamed(context, '/notifications'),
                onProfile: () => context.push('/profile'),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 40),

                /// Upload Card
                Expanded(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () => _showImageSourceSheet(context),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isDarkMode
                                  ? Colors.grey[700]!
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            color: isDarkMode ? Colors.grey[800] : Colors.white,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.upload_file,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 12),
                                const Text("Tap to upload file or video"),

                                if (state.status is ApiLoading) ...[
                                  const SizedBox(height: 20),
                                  Text("Uploading… $progress%"),
                                  LinearProgressIndicator(
                                    value: progress / 100,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// Upload New File button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showImageSourceSheet(context),
                    child: const Text("Upload New File"),
                  ),
                ),

                const SizedBox(height: 12),

                /// NEW: Result Screen button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.push('/result'),
                    child: const Text("Go to Result Screen"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
