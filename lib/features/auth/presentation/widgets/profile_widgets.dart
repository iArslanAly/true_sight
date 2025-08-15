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
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
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
