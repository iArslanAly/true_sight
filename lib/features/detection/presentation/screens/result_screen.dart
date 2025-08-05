import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result Screen'), centerTitle: true),
      body: Center(
        child: Text(
          'Here are your results',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
