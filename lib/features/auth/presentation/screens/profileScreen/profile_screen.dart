import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:true_sight/core/constants/colors.dart';
import 'package:true_sight/core/cubits/permission_cubit.dart';
import 'package:true_sight/core/logging/logger.dart';
import 'package:true_sight/core/utils/image_picker.dart';
import 'package:true_sight/core/utils/status/auth_status.dart';
import 'package:true_sight/core/widgets/custom_dialog.dart';
import 'package:true_sight/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:true_sight/features/auth/presentation/widgets/profile_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  Future<void> _pickImage(BuildContext context, ImageSourceType type) async {
    final permissionCubit = context.read<PermissionCubit>();

    Permission permission;
    if (Platform.isIOS) {
      permission = type == ImageSourceType.camera
          ? Permission.camera
          : Permission.photos; // iOS 14+ will show the picker
    } else {
      permission = type == ImageSourceType.camera
          ? Permission.camera
          : Permission.photos;
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
      final file = type == ImageSourceType.camera
          ? await picker.pickFromCamera(type: ImageType.profile)
          : await picker.pickFromGallery(type: ImageType.profile);

      if (file != null) {
        context.read<AuthBloc>().add(AuthUpdateProfileImageEvent(file));
      }
    } else if (result is PermissionSuggestSettings) {
      // User permanently denied, suggest opening settings
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
      // Simple denied case
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Permission denied")));
    }
  }

  Widget _profileImage(BuildContext context, String? photoUrl) {
    ImageProvider? image;

    if (photoUrl != null && photoUrl.isNotEmpty) {
      if (photoUrl.startsWith('http')) {
        // Google login URL
        image = NetworkImage(photoUrl);
      } else {
        // Local file uploaded by user
        final file = File(photoUrl);
        if (file.existsSync()) {
          image = FileImage(file);
        }
      }
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 55,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: image,
          child: image == null
              ? const Icon(Icons.person, size: 55, color: Colors.grey)
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) => SafeArea(
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
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: XColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.camera_alt,
                color: XColors.darkGrey,
                size: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status is AuthLoggedOut) {
          context.go('/welcome');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.go('/upload'),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                context.push('/settings');
              },
            ),
          ],
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.status is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status is AuthFailure) {
              final failure = state.status as AuthFailure;
              return Center(child: Text('Error: ${failure.errorMessage}'));
            }

            final user = state.user;
            if (user == null) {
              return const Center(child: Text("No user available"));
            }

            XLoggerHelper.debug(
              user.photoUrl != null
                  ? 'User photo URL: ${user.photoUrl}'
                  : 'User photo URL is null',
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      _profileImage(context, user.photoUrl),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            user.email,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            child: SizedBox(
                              width: 90,
                              child: Container(
                                height: 25,

                                decoration: BoxDecoration(
                                  color: XColors.secondary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    'Edit Profile',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  const SizedBox(height: 4),
                  Text(
                    user.createdAt != null
                        ? user.createdAt!.toLocal().toString().split(' ')[0]
                        : '',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  buildProfileFeatures(
                    context,
                    'Language',
                    Icons.language,
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  buildProfileFeatures(
                    context,
                    'Location',
                    Icons.location_on,
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  buildProfileFeatures(
                    context,
                    'Subscription',
                    Icons.subscriptions,
                  ),
                  const SizedBox(height: 10),
                  buildProfileDivider(context),
                  buildProfileFeatures(context, 'Clear Cache', Icons.delete),
                  const SizedBox(height: 10),
                  buildProfileFeatures(context, 'Clear History', Icons.history),
                  const SizedBox(height: 10),
                  buildProfileFeatures(
                    context,
                    'Logout',
                    Icons.logout,
                    color: XColors.error,
                    onTap: () async {
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => CustomDialog(
                          title: 'Confirm Logout',
                          content: 'Are you sure you want to logout?',
                          cancelText: 'Cancel',
                          confirmText: 'Logout',
                        ),
                      );

                      if (shouldLogout == true) {
                        context.read<AuthBloc>().add(AuthLogoutEvent());
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

enum ImageSourceType { camera, gallery }
