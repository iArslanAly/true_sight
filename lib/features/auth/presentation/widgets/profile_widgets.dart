import 'dart:io';

import 'package:flutter/material.dart';
import 'package:true_sight/core/constants/colors.dart';

Widget buildProfileFeatures(
  BuildContext context,

  String title,
  IconData icon, {
  Color? color,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
        left: 8.0,
        right: 16.0,
      ),
      child: Row(
        children: [
          Icon(icon, color: color ?? XColors.darkGrey),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
          ),
          const Spacer(),

          const Icon(Icons.arrow_forward_ios, color: XColors.darkGrey),
        ],
      ),
    ),
  );
}

Widget buildProfileDivider(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: Divider(color: Theme.of(context).dividerColor, thickness: 1.5),
  );
}

enum ImageSourceType { camera, gallery }

class ProfileImage extends StatelessWidget {
  final String? photoUrl;
  final File? localImage;
  final double radius;
  final VoidCallback? onCameraTap;
  final VoidCallback? onGalleryTap;
  final Color primaryColor;
  final Color iconColor;

  const ProfileImage({
    super.key,
    this.photoUrl,
    this.localImage,
    this.radius = 55,
    this.onCameraTap,
    this.onGalleryTap,
    this.primaryColor = Colors.blue, // Default, can override
    this.iconColor = Colors.white, // Default, can override
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? image;

    if (localImage != null) {
      image = FileImage(localImage!); // prefer picked image
    } else if (photoUrl != null && photoUrl!.isNotEmpty) {
      if (photoUrl!.startsWith('http')) {
        image = NetworkImage(photoUrl!);
      } else {
        final file = File(photoUrl!);
        if (file.existsSync()) {
          image = FileImage(file);
        }
      }
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: radius,
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
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (onCameraTap != null)
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text("Take Photo"),
                            onTap: () {
                              Navigator.pop(context);
                              onCameraTap!();
                            },
                          ),
                        if (onGalleryTap != null)
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text("Choose from Gallery"),
                            onTap: () {
                              Navigator.pop(context);
                              onGalleryTap!();
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.camera_alt, color: iconColor, size: 15),
            ),
          ),
        ),
      ],
    );
  }
}
