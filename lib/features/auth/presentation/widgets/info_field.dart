import 'package:flutter/material.dart';
import 'package:true_sight/core/constants/sizes.dart';

class InfoField extends StatelessWidget {
  final String label;
  final String value;

  const InfoField({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: XSizes.d16,
          vertical: XSizes.d12,
        ),
      ),
    );
  }
}
