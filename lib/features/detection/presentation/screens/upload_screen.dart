import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:true_sight/core/utils/navigation_helper.dart';
import 'package:true_sight/core/widgets/flashbar_helper.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extras = GoRouterState.of(context).extra as Map<String, String>?;
    if (extras != null && extras.isNotEmpty && LoginExtrasCache.consumeOnce()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FlushbarHelper.showSuccess(
          context,
          title: extras['title'] ?? '',
          message: extras['message'] ?? '',
        );
      });
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Screen'), centerTitle: true),
      body: Center(
        child: Text(
          'Upload your files here',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
