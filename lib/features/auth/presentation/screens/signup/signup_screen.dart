import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup Screen'), centerTitle: true),
      body: Center(
        child: Text(
          'Create a new account',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
