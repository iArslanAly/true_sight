// lib/core/services/otp_config_service.dart
import 'package:email_otp/email_otp.dart';

class OTPConfigService {
  static void init() {
    EmailOTP.config(
      appName: 'TrueSight',
      otpType: OTPType.numeric,
      expiry: 100000,
      appEmail: 'iarslanali0@gmail.com',
      otpLength: 4,
    );
  }

  static const String otpTemplate = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{{appName}} - OTP Verification</title>
</head>
<body style="margin:0; padding:0; background-color:#f4f4f4; font-family:'Segoe UI', Arial, sans-serif; color:#e5e5e5;">
  <table width="100%" cellspacing="0" cellpadding="0" style="background-color:#121212; padding:40px 0;">
    <tr>
      <td align="center">
        <table width="100%" cellspacing="0" cellpadding="0" style="max-width:600px; background-color:#1e1e1e; border-radius:12px; overflow:hidden; box-shadow:0 4px 20px rgba(0,0,0,0.4);">
          
          <!-- Header -->
          <tr>
            <td style="background-color:#000000; padding:20px; text-align:center;">
              <h1 style="color:#ffffff; font-size:24px; margin:0; font-weight:600; letter-spacing:1px;">
                {{appName}}
              </h1>
            </td>
          </tr>

          <!-- Body -->
          <tr>
            <td style="padding:30px; color:#e5e5e5;">
              <p style="font-size:18px; font-weight:500; margin-bottom:15px;">Hello,</p>
              <p style="font-size:15px; line-height:1.6; margin-bottom:20px;">
                We received a request to verify your identity. Please use the One-Time Password (OTP) below to proceed.
              </p>

              <!-- OTP Box -->
              <div style="text-align:center; margin:30px 0;">
                <span style="display:inline-block; background-color:#000000; color:#ffffff; font-size:28px; font-weight:700; letter-spacing:8px; padding:15px 25px; border-radius:8px; border:1px solid #333;">
                  {{otp}}
                </span>
              </div>

              <p style="font-size:13px; color:#bbbbbb; margin-bottom:15px;">
                This OTP will expire in <strong>5 minutes</strong>.
              </p>
              <p style="font-size:13px; color:#bbbbbb; margin-bottom:30px;">
                If you did not request this code, please ignore this email or contact our support team immediately.
              </p>

              <p style="font-size:13px; color:#888888; margin-top:30px;">
                Sent on: <strong>{{dateTime}}</strong>
              </p>

              <p style="font-size:13px; color:#888888; margin-top:10px;">
                Thank you,<br>
                <strong>{{appName}} Security Team</strong>
              </p>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="background-color:#000000; padding:15px; text-align:center; font-size:11px; color:#666;">
              &copy; {{year}} {{appName}}. All rights reserved.
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>
''';
}
