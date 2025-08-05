import 'package:flutter/material.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
