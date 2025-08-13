import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:true_sight/core/constants/colors.dart';
import 'package:true_sight/core/constants/sizes.dart';
import 'package:true_sight/core/constants/text_strings.dart';
import 'package:true_sight/core/logging/logger.dart';
import 'package:true_sight/core/utils/status/auth_status.dart';
import 'package:true_sight/core/validators/validators.dart';
import 'package:true_sight/core/widgets/flashbar_helper.dart';
import 'package:true_sight/core/widgets/loading_dialogue.dart';
import 'package:true_sight/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:true_sight/features/auth/presentation/cubit/resend_cooldown_cubit.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  void _submitResetRequest(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();

      context.read<ResendCooldownCubit>().startCooldown();
      context.read<AuthBloc>().add(AuthSendOtpEvent(email: email));
      XLoggerHelper.debug('Reset password request for email: $email');
      context.go('/otp', extra: email);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (mounted) {
            if (state.status is AuthLoading) {
              LoadingDialog.show(context);
            } else {
              LoadingDialog.hide(context);
            }
            if (state.status is AuthFailure) {
              final failure = (state.status as AuthFailure);
              FlushbarHelper.showError(
                context,
                title: 'Error',
                message: failure.errorMessage,
              );
            } else if (state.status is AuthSuccess) {
              final success = (state.status as AuthSuccess);
              if (success.otpSent) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('An OTP has been sent to ${state.email}'),
                  ),
                );
                // Navigate to OTP screen with email
                context.go('/otp', extra: state.email);
              }
            }
          }
        },
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                // Make the scrollable area at least as tall as the viewport:
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ─── Your Title at the Top ───
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

                        // ─── Centered Form ───
                        // This flex child will expand to fill the **remaining** space,
                        // then Center will vertically center its child (the form).
                        Expanded(
                          child: Align(
                            alignment: const Alignment(XSizes.d0, -0.3),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: XSizes.d16,
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      XTextStrings.authForgotPasswordTitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .apply(fontWeightDelta: XSizes.i5),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: XSizes.spaceBtwItems,
                                    ),
                                    Text(
                                      XTextStrings.authForgotPasswordSubtitle,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall!,
                                    ),
                                    const SizedBox(
                                      height: XSizes.spaceBtwSections,
                                    ),
                                    TextFormField(
                                      controller: _emailController,
                                      validator: EValidators.validateEmail,
                                      keyboardType: TextInputType.emailAddress,
                                      autovalidateMode:
                                          AutovalidateMode.onUnfocus,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.email_outlined,
                                          color: XColors.secondary,
                                        ),
                                        labelText: XTextStrings.authEmail,
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: XSizes.spaceBtwInputFields,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            _submitResetRequest(context),
                                        child: Text(
                                          XTextStrings.authVerifyEmailTitle,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: XSizes.spaceBtwSections,
                                    ),
                                    GestureDetector(
                                      onTap: () => context.go('/login'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            XTextStrings.authRememberPassword,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
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
                        ),

                        // ─── Optional footer or spacer ───
                        const SizedBox(height: XSizes.d50),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Extracted the form-building into its own method for clarity:
}
