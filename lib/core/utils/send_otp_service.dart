import 'package:email_otp/email_otp.dart';
import 'package:true_sight/core/logging/logger.dart';

extension EmailOtpSenderExtension on EmailOTP {
  Future<void> sendOtpTo(String userEmail) async {
    EmailOTP.config(
      appEmail: "mehararslanali462@gmail.com",
      appName: "TrueSight",
      emailTheme: EmailTheme.v6,
      otpLength: 4,
      otpType: OTPType.numeric,
    );

    final isSent = await EmailOTP.sendOTP(email: userEmail);

    if (!isSent) {
      throw Exception("❌ Failed to send OTP to $userEmail");
    }
  }

  Future<bool> verify(String otp) async {
    final isValid = EmailOTP.verifyOTP(otp: otp);
    if (isValid) {
      XLoggerHelper.debug("✅ OTP verified successfully!");
    } else {
      XLoggerHelper.debug("❌ Invalid OTP");
    }
    return isValid;
  }
}
