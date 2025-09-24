import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:true_sight/core/widgets/appbar.dart';

import 'package:true_sight/features/auth/presentation/bloc/auth_bloc.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return TopAppBar(
              name: state.user?.name ?? 'User',
              avatarUrl: state.user?.photoUrl,
              unreadNotifications: 3,

              onBack: () => Navigator.pop(context),
              onHistory: () => context.push('/history'),
              onNotifications: () =>
                  Navigator.pushNamed(context, '/notifications'),
              onProfile: () => context.push('/profile'),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
        child: Column(
          children: [
            const SizedBox(height: 40),

            /// Upload Card
            Expanded(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Handle tap to upload
                    },
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
                          children: const [
                            Icon(
                              Icons.upload_file,
                              size: 60,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 12),
                            Text("Tap to upload file or video"),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Result button (only show when result is ready)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/result');
                      },
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                      label: const Text(
                        "View Result",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode
                            ? Colors.green
                            : Colors.green[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Pick file/video
                },
                child: const Text("Upload New File"),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
