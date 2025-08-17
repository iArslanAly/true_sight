import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:true_sight/core/constants/colors.dart';
import 'package:true_sight/core/cubits/permission_cubit.dart';
import 'package:true_sight/core/cubits/theme_cubit.dart';
import 'package:true_sight/core/utils/image_picker.dart';
import 'package:true_sight/core/utils/status/auth_status.dart';
import 'package:true_sight/core/widgets/custom_dialog.dart';
import 'package:true_sight/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:true_sight/features/auth/presentation/widgets/profile_widgets.dart';

enum ImageSourceType { camera, gallery }

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
        context.read<AuthBloc>().add(AuthUpdateProfileImageEvent(file));
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

  // Add this helper inside ProfileScreen class
  Widget _buildCustomSwitch(
    BuildContext context, {
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: isDark ? Colors.black : Colors.black,
      inactiveThumbColor: isDark ? XColors.white : Colors.black,
      activeTrackColor: isDark ? Colors.white : Colors.black,
      inactiveTrackColor: isDark ? Colors.black : Colors.white,
    );
  }

  Widget _buildSettingTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? XColors.darkGrey),
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
      ),
      trailing: trailing,
      onTap: onTap,
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
          toolbarHeight: 60,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                // Open settings modal
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder: (ctx) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildSettingTile(
                            context: context,
                            icon: Icons.brightness_6,
                            title: "Dark Mode",
                            trailing: BlocBuilder<ThemeCubit, ThemeData>(
                              builder: (context, theme) {
                                return _buildCustomSwitch(
                                  context,
                                  value: theme.brightness == Brightness.dark,
                                  onChanged: (_) =>
                                      context.read<ThemeCubit>().toggleTheme(),
                                );
                              },
                            ),
                          ),

                          _buildSettingTile(
                            context: context,
                            icon: Icons.notifications,
                            title: "Notifications",
                            trailing: BlocBuilder<ThemeCubit, ThemeData>(
                              builder: (context, theme) {
                                return _buildCustomSwitch(
                                  context,
                                  value: theme.brightness == Brightness.dark,
                                  onChanged: (val) {
                                    // handle notification toggle
                                  },
                                );
                              },
                            ),
                          ),

                          _buildSettingTile(
                            context: context,
                            icon: Icons.info_outline,
                            title: "App Version",
                            trailing: const Text("1.0.0"),
                          ),
                          _buildSettingTile(
                            context: context,
                            icon: Icons.privacy_tip,
                            title: "Privacy Policy",
                            onTap: () {},
                          ),
                          _buildSettingTile(
                            context: context,
                            icon: Icons.help_outline,
                            title: "Help & FAQ",
                            onTap: () {},
                          ),
                        ],
                      ),
                    );
                  },
                );
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

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  Row(
                    
                    children: [
                      ProfileImage(
                        photoUrl: user.photoUrl,
                        onCameraTap: () =>
                            _pickImage(context, ImageSourceType.camera),
                        onGalleryTap: () =>
                            _pickImage(context, ImageSourceType.gallery),
                        primaryColor: Colors.deepPurple,
                        iconColor: Colors.white,
                      ),

                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                user.name,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 4),
                              if (user.emailVerified ||
                                  user.provider == 'google')
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 16,
                                )
                              else
                                Text(
                                  ' (Unverified)',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.red),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              context.push('/edit-profile');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: XColors.secondary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Edit Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // User features
                  buildProfileFeatures(context, 'Language', Icons.language),
                  buildProfileFeatures(context, 'Location', Icons.location_on),
                  buildProfileFeatures(
                    context,
                    'Subscription',
                    Icons.subscriptions,
                  ),
                  buildProfileDivider(context),
                  buildProfileFeatures(context, 'Clear Cache', Icons.delete),
                  buildProfileFeatures(context, 'Clear History', Icons.history),
                  buildProfileDivider(context),
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
