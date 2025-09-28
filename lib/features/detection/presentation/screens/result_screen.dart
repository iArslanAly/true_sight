import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:true_sight/features/detection/presentation/bloc/detection_bloc.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final detectionState = context.watch<DetectionBloc>().state;
    final result = detectionState.detectionResult;

    if (result == null) {
      // If user somehow lands here without data
      return const Scaffold(body: Center(child: Text('No result available')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detection Result')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'File: ${result.originalFileName}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              'Status: ${result.overallStatus}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: result.overallStatus == 'AUTHENTIC'
                    ? Colors.green
                    : Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            Text('Media Type: ${result.mediaType}'),
            const SizedBox(height: 12),
            Text('Request ID: ${result.requestId}'),
            const SizedBox(height: 12),
            if (result.thumbnail.isNotEmpty)
              Image.network(result.thumbnail, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 12),
            Text('Created At: ${result.createdAt}'),
            const SizedBox(height: 12),
            Text('Summary: ${result.resultsSummary.toString()}'),
          ],
        ),
      ),
    );
  }
}
