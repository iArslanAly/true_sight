import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:true_sight/core/constants/colors.dart';
import 'package:true_sight/core/constants/sizes.dart';
import 'package:true_sight/core/validators/validators.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: dispatch your update-password event/use-case here
      context.go('/login'); // for example, back to login screen
    }
  }

  @override
  void dispose() {
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // ───────────────── Top Title ─────────────────
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

                  // ───────────────── Center Form ─────────────────
                  Expanded(
                    child: Align(
                      alignment: const Alignment(0, -0.2),
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
                                'Update Password',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              ),
                              Text(
                                'Enter your new password below',
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: XSizes.spaceBtwSections),

                              // New Password
                              TextFormField(
                                controller: _newPassController,
                                validator: EValidators.validatePassword,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  labelText: 'New Password',
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: XColors.secondary,
                                  ),

                                  border: const OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(
                                height: XSizes.spaceBtwInputFields,
                              ),

                              // Confirm Password
                              TextFormField(
                                controller: _confirmPassController,
                                keyboardType: TextInputType.visiblePassword,
                                validator: (val) =>
                                    EValidators.validateConfirmPassword(
                                      val,
                                      _newPassController.text,
                                    ),
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: XColors.secondary,
                                  ),

                                  border: const OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: XSizes.spaceBtwSections),

                              // Submit Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _submit,
                                  child: const Text('Save New Password'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ───────────────── Bottom Spacer ─────────────────
                  const SizedBox(height: XSizes.d50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
