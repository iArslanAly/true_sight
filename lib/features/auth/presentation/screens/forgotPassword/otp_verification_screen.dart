import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:true_sight/core/constants/sizes.dart';
import 'package:true_sight/core/constants/text_strings.dart';
import 'package:true_sight/core/logging/logger.dart';
import 'package:true_sight/core/utils/send_otp_service.dart';
import 'package:true_sight/features/auth/presentation/cubit/otp_cubit.dart';
import 'package:true_sight/features/auth/presentation/cubit/resend_cooldown_cubit.dart';
import 'package:true_sight/widgets/otp_field.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  Future<void> _verifyOtp(BuildContext context) async {
    XLoggerHelper.debug("OTP Verify clicked");

    final cubit = context.read<OtpCubit>();
    final otp = cubit.otp;

    if (!cubit.isOtpValid) {
      XLoggerHelper.debug("Invalid OTP format");
      return;
    }

    XLoggerHelper.debug("OTP entered: $otp");
    final isVerified = await cubit.emailOtp.verify(otp); // ✅ Same instance

    if (!isVerified) {
      XLoggerHelper.debug("Incorrect OTP");
      return;
    }

    XLoggerHelper.debug("OTP verified ✅ Navigating to update-password");
    // context.go('/update-password');
    // cubit.resetOtpFields();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OtpCubit>();
    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // ─── Top Title ───
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: XSizes.d16,
                        vertical: XSizes.d24,
                      ),
                      child: Text(
                        'TrueSight',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge!
                            .copyWith(
                              fontFamily: 'Formula',
                              fontSize: XSizes.d50,
                            ),
                      ),
                    ),

                    // ─── Centered OTP Form ───
                    Expanded(
                      child: Align(
                        alignment: const Alignment(0, -0.2),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: XSizes.d32,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Verify Otp',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              ),
                              Text(
                                'Enter the 4-digit code sent to your email',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: XSizes.spaceBtwSections),

                              // OTP text fields
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(4, (i) {
                                  return OtpInputField(
                                    controller: cubit.digitControllers[i],
                                    currentFocus: cubit.focusNodes[i],
                                    nextFocus: i < 3
                                        ? cubit.focusNodes[i + 1]
                                        : null,
                                    previousFocus: i > 0
                                        ? cubit.focusNodes[i - 1]
                                        : null,
                                  );
                                }),
                              ),

                              const SizedBox(height: XSizes.spaceBtwSections),
                              BlocBuilder<ResendCooldownCubit, int>(
                                builder: (context, state) {
                                  return state > 0
                                      ? Text(
                                          'Resend in 00:${state.toString().padLeft(2, '0')}',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        )
                                      : TextButton(
                                          onPressed: () {
                                            context
                                                .read<ResendCooldownCubit>()
                                                .startCooldown();
                                          },
                                          child: const Text('Resend Code'),
                                        );
                                },
                              ),
                              const SizedBox(height: XSizes.spaceBtwItems),

                              // Verify Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => _verifyOtp(context),
                                  child: const Text('Verify'),
                                ),
                              ),
                              const SizedBox(height: XSizes.spaceBtwItems),
                              GestureDetector(
                                onTap: () => context.go('/login'),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      XTextStrings.authRememberPassword,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge!,
                                    ),
                                    Text(
                                      XTextStrings.authLoginButtonText,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ─── Bottom Spacer ───
                    const SizedBox(height: XSizes.d50),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
