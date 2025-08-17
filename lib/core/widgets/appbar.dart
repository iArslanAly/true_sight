import 'package:flutter/material.dart';

/// Reusable top app bar used on Upload / Home screens.
///
/// Example:
/// appBar: TopAppBar(
///   name: state.user?.name ?? 'User',
///   avatarUrl: state.user?.photoUrl,
///   unreadNotifications: 3,
///   onBack: () => context.pop(),
///   onHistory: () => Navigator.pushNamed(context, '/history'),
///   onNotifications: () => Navigator.pushNamed(context, '/notifications'),
///   onProfile: () => Navigator.pushNamed(context, '/profile'),
/// ),
class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String welcomeText;
  final String name;
  final String? avatarUrl;
  final int unreadNotifications;
  final bool showBack;
  final VoidCallback? onBack;
  final VoidCallback? onHistory;
  final VoidCallback? onNotifications;
  final VoidCallback? onProfile;
  final double height;

  const TopAppBar({
    super.key,
    this.welcomeText = 'Welcome,',
    required this.name,
    this.avatarUrl,
    this.unreadNotifications = 0,
    this.showBack = false,
    this.onBack,
    this.onHistory,
    this.onNotifications,
    this.onProfile,
    this.height = 84.0,
  });

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.iconTheme.color ?? Colors.black87;
    final titleStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.bold,
    );
    final subtitleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );

    return SafeArea(
      bottom: false,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        color: theme.scaffoldBackgroundColor,
        child: Row(
          children: [
            if (showBack)
              IconButton(
                icon: Icon(Icons.arrow_back_ios, color: iconColor),
                onPressed: onBack ?? () => Navigator.maybePop(context),
                splashRadius: 20,
              )
            else
              const SizedBox(width: 6),

            // Title area
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(welcomeText, style: subtitleStyle),
                  const SizedBox(height: 2),
                  Text(name, style: titleStyle),
                ],
              ),
            ),

            // History button
            IconButton(
              tooltip: 'History',
              icon: Icon(Icons.history_outlined, color: iconColor),
              onPressed: onHistory,
              splashRadius: 20,
            ),

            // Notifications + badge
            Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    tooltip: 'Notifications',
                    icon: Icon(Icons.notifications_outlined, color: iconColor),
                    onPressed: onNotifications,
                    splashRadius: 20,
                  ),
                  if (unreadNotifications > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 16,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          unreadNotifications > 99
                              ? '99+'
                              : '$unreadNotifications',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Profile avatar
            GestureDetector(
              onTap: onProfile,
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: theme.dividerColor,
                  foregroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
                      ? NetworkImage(avatarUrl!)
                      : null,
                  child: avatarUrl == null || avatarUrl!.isEmpty
                      ? Text(
                          _initials(name),
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
