import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpCubit extends Cubit<void> {
  final emailOtp = EmailOTP();
  final List<TextEditingController> digitControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  OtpCubit() : super(null);

  String get otp => digitControllers.map((c) => c.text).join();

  bool get isOtpValid => digitControllers.every((c) => c.text.isNotEmpty);

  // 👇 call this manually when leaving the OTP screen
  void resetOtpFields() {
    digitControllers.clear();
    focusNodes.clear();

    digitControllers.addAll(List.generate(4, (_) => TextEditingController()));
    focusNodes.addAll(List.generate(4, (_) => FocusNode()));
  }
}
