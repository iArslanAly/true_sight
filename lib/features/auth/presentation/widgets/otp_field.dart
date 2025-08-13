// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:true_sight/core/constants/sizes.dart';

class OtpInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode
  textFieldFocusNode; // create & pass from parent/cubit (non-null)
  final FocusNode? nextFocus;
  final FocusNode? previousFocus;
  final TextEditingController? previousController; // optional, to clear prev

  const OtpInputField({
    super.key,
    required this.controller,
    required this.textFieldFocusNode,
    this.nextFocus,
    this.previousFocus,
    this.previousController,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late final FocusNode _rawKeyboardNode;
  String _lastValue = '';

  @override
  void initState() {
    super.initState();
    _rawKeyboardNode = FocusNode(debugLabel: 'otp_raw_keyboard_node');

    // Listen to textField focus to give raw listener focus too
    widget.textFieldFocusNode.addListener(_onTextFieldFocusChanged);
    _lastValue = widget.controller.text;
  }

  void _onTextFieldFocusChanged() {
    if (widget.textFieldFocusNode.hasFocus) {
      // give the RawKeyboardListener focus so it receives physical key events
      if (!_rawKeyboardNode.hasFocus) _rawKeyboardNode.requestFocus();
    } else {
      if (_rawKeyboardNode.hasFocus) _rawKeyboardNode.unfocus();
    }
  }

  @override
  void didUpdateWidget(covariant OtpInputField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the parent replaced the FocusNode instance, update listeners safely
    if (oldWidget.textFieldFocusNode != widget.textFieldFocusNode) {
      try {
        oldWidget.textFieldFocusNode.removeListener(_onTextFieldFocusChanged);
      } catch (_) {}
      widget.textFieldFocusNode.addListener(_onTextFieldFocusChanged);
      // sync raw node focus
      if (widget.textFieldFocusNode.hasFocus && !_rawKeyboardNode.hasFocus) {
        _rawKeyboardNode.requestFocus();
      } else if (!widget.textFieldFocusNode.hasFocus &&
          _rawKeyboardNode.hasFocus) {
        _rawKeyboardNode.unfocus();
      }
    }
  }

  @override
  void dispose() {
    try {
      widget.textFieldFocusNode.removeListener(_onTextFieldFocusChanged);
    } catch (_) {}
    _rawKeyboardNode.dispose();
    super.dispose();
  }

  // Handle Raw keyboard events (hardware/backspace)
  KeyEventResult _onKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        final text = widget.controller.text;
        if (text.isEmpty) {
          // current field empty + backspace -> move to previous and clear it
          if (widget.previousFocus != null) {
            widget.previousFocus!.requestFocus();
            widget.previousController?.clear();
          }
          return KeyEventResult.handled;
        }
        // if we had text here, let TextField handle deletion
        return KeyEventResult.ignored;
      }
    }
    return KeyEventResult.ignored;
  }

  // onChanged handles forward movement and deletion when TextField changes
  void _onChanged(String value) {
    // If user pasted or typed multiple digits, keep last char
    if (value.length > 1) {
      final last = value.substring(value.length - 1);
      widget.controller.text = last;
      widget.controller.selection = TextSelection.collapsed(
        offset: last.length,
      );
    }

    // If a digit entered -> move forward
    if (widget.controller.text.isNotEmpty) {
      widget.nextFocus?.requestFocus();
    }

    // If user deleted a non-empty value to empty, move to previous (fallback)
    if (_lastValue.isNotEmpty && widget.controller.text.isEmpty) {
      if (widget.previousFocus != null) {
        widget.previousFocus!.requestFocus();
        // optionally clear previousController? keep UX consistent:
        // widget.previousController?.clear();
      }
    }

    _lastValue = widget.controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: XSizes.d70,
      height: XSizes.d70,
      child: RawKeyboardListener(
        focusNode: _rawKeyboardNode,
        onKey: _onKey,
        child: TextField(
          controller: widget.controller,
          focusNode: widget.textFieldFocusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontSize: XSizes.d18),
          maxLength: 1,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          decoration: const InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.symmetric(vertical: XSizes.d24),
            border: OutlineInputBorder(),
          ),
          onChanged: _onChanged,
        ),
      ),
    );
  }
}
