import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode currentFocus;
  final FocusNode? nextFocus;
  final FocusNode? previousFocus;

  const OtpInputField({
    super.key,
    required this.controller,
    required this.currentFocus,
    this.nextFocus,
    this.previousFocus,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: TextFormField(
        controller: controller,
        focusNode: currentFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        textInputAction: nextFocus != null
            ? TextInputAction.next
            : TextInputAction.done,
        maxLength: 1,
        style: Theme.of(context).textTheme.headlineSmall,
        decoration: const InputDecoration(
          counterText: '',
          border: OutlineInputBorder(),
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (val) {
          if (val.length == 1) {
            if (nextFocus != null) {
              FocusScope.of(context).requestFocus(nextFocus);
            } else {
              FocusScope.of(context).unfocus();
            }
          } else if (val.isEmpty && previousFocus != null) {
            controller.clear();
            FocusScope.of(context).requestFocus(previousFocus);
          }
        },
      ),
    );
  }
}
