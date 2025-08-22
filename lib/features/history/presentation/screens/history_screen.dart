import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with your actual history data
    final List<String> historyItems = ['Item 1', 'Item 2', 'Item 3'];

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: historyItems.isEmpty
          ? const Center(child: Text('No history available.'))
          : ListView.builder(
              itemCount: historyItems.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(historyItems[index]));
              },
            ),
    );
  }
}
