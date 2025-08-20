import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:true_sight/core/constants/colors.dart';
import 'package:true_sight/core/cubits/permission_cubit.dart';
import 'package:true_sight/core/logging/logger.dart';
import 'package:true_sight/core/utils/image_picker.dart';
import 'package:true_sight/core/utils/status/auth_status.dart';
import 'package:true_sight/core/widgets/country_dropdown.dart';
import 'package:true_sight/core/widgets/custom_dialog.dart';
import 'package:true_sight/core/widgets/flashbar_helper.dart';
import 'package:true_sight/core/widgets/loading_dialogue.dart';
import 'package:true_sight/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:true_sight/features/auth/presentation/cubit/profile_cubit.dart';
import 'package:true_sight/features/auth/presentation/widgets/gender_dropdown.dart';
import 'package:true_sight/features/auth/presentation/widgets/profile_widgets.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

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
        context.read<EditProfileCubit>().setPickedImage(file);
        XLoggerHelper.debug("Picked image: ${file.path}");
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

  Widget _customTextField({
    required BuildContext context,
    required TextEditingController controller,
    required bool isEditing,
    required String label,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDarkMode ? XColors.white : XColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: isEditing,
          style: TextStyle(color: isDarkMode ? XColors.white : XColors.black),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status is AuthLoading) {
          LoadingDialog.show(context);
        } else {
          LoadingDialog.hide(context);
        }
        if (state.status is AuthFailure) {
          final failure = state.status as AuthFailure;
          FlushbarHelper.showError(context, message: failure.errorMessage);
        }
        if (state.status is AuthSuccess) {
          FlushbarHelper.showSuccess(
            context,
            message: "Profile updated successfully!",
          );

          // ✅ Exit editing mode only after success
          context.read<EditProfileCubit>().toggleEditing();
        }
      },
      builder: (context, authState) {
        final user = authState.user;
        final cubit = context.read<EditProfileCubit>();

        // Prefill once
        if (user != null && cubit.nameController.text.isEmpty) {
          cubit.nameController.text = user.name;
          cubit.emailController.text = user.email;
          cubit.selectedGender = user.gender;
          cubit.selectedCountry = user.country;
        }

        return BlocBuilder<EditProfileCubit, bool>(
          builder: (context, isEditing) {
            final theme = Theme.of(context);

            return WillPopScope(
              onWillPop: () async {
                if (isEditing) {
                  final shouldDiscard = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => CustomDialog(
                      title: "Discard changes?",
                      content:
                          "You have unsaved changes. Do you want to discard them?",
                      cancelText: "Cancel",
                      confirmText: "Discard",
                      onConfirm: () => Navigator.of(ctx).pop(true),
                    ),
                  );

                  if (shouldDiscard == true) {
                    // ✅ Reset to user data
                    if (user != null) {
                      cubit.nameController.text = user.name;
                      cubit.emailController.text = user.email;
                      cubit.selectedGender = user.gender;
                      cubit.selectedCountry = user.country;
                      cubit.setPickedImage(null);
                    }
                    cubit.toggleEditing();
                    return true;
                  }
                  return false;
                }
                return true;
              },
              child: Scaffold(
                appBar: AppBar(
                  toolbarHeight: 60,
                  title: const Text("Edit Profile"),
                  centerTitle: true,
                  leading: BackButton(
                    color: isDarkMode ? XColors.white : XColors.black,
                  ), // ✅ uses WillPopScope
                  elevation: 0,
                  actions: [
                    if (!isEditing)
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => cubit.toggleEditing(),
                      ),
                  ],
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      /// Profile photo + name container
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? XColors.darkerGrey
                              : XColors.lightGrey,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            if (isEditing)
                              ProfileImage(
                                localImage: cubit.pickedImage,
                                photoUrl: user?.photoUrl,
                                onCameraTap: () =>
                                    _pickImage(context, ImageSourceType.camera),
                                onGalleryTap: () => _pickImage(
                                  context,
                                  ImageSourceType.gallery,
                                ),
                              )
                            else
                              CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage: user?.photoUrl != null
                                    ? NetworkImage(user!.photoUrl!)
                                    : null,
                                child: user?.photoUrl == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 55,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.name ?? "No Name",
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Created At: ${user?.createdAt?.year.toString() ?? "N/A"}',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: XColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// Fields container
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? XColors.darkerGrey
                              : XColors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _customTextField(
                              context: context,
                              controller: cubit.nameController,
                              isEditing: isEditing,
                              label: "Full Name",
                            ),
                            const SizedBox(height: 16),
                            _customTextField(
                              context: context,
                              controller: cubit.emailController,
                              isEditing: isEditing,
                              label: "Email",
                            ),
                            const SizedBox(height: 16),
                            GenderDropdown(
                              enabled: isEditing,
                              selectedGender: cubit.selectedGender?.trim(),
                              onChanged: (value) {
                                cubit.selectedGender = value;
                              },
                            ),
                            const SizedBox(height: 16),
                            CountryDropdown(
                              enabled: isEditing,
                              selectedCountry: cubit.selectedCountry?.trim(),
                              onChanged: (value) {
                                cubit.selectedCountry = value;
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// Save button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (isEditing) {
                              final editCubit = context
                                  .read<EditProfileCubit>();
                              final photoFile = editCubit.pickedImage;

                              context.read<AuthBloc>().add(
                                UpdateUserEvent(
                                  name: cubit.nameController.text.trim(),
                                  email: cubit.emailController.text.trim(),
                                  gender: cubit.selectedGender ?? '',
                                  country: cubit.selectedCountry ?? '',
                                  photoUrl: photoFile,
                                ),
                              );
                            } else {
                              cubit.toggleEditing();
                            }
                          },
                          child: Text(
                            isEditing ? 'Save Changes' : 'Edit Profile',
                            style: TextStyle(
                              fontSize: 16,
                              color: isDarkMode ? XColors.black : XColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
