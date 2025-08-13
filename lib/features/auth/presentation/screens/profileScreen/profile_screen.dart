import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:true_sight/core/constants/sizes.dart';
import 'package:true_sight/core/constants/text_strings.dart';
import 'package:true_sight/core/utils/status/auth_status.dart';
import 'package:true_sight/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:true_sight/features/auth/presentation/widgets/info_field.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        final status = state.status;
        if (status is AuthSuccess) {
          context.go('/welcome');
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final status = state.status;

            if (status is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (status is AuthFailure) {
              return Center(child: Text('Error: ${status.errorMessage}'));
            }

            final user = state.user;

            if (user == null) {
              return const Center(child: Text(XTextStrings.profileNoUser));
            }

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: XSizes.d450),
                child: Padding(
                  padding: const EdgeInsets.all(XSizes.d24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(XSizes.d100),
                        child: user.photoUrl != null
                            ? Image.network(
                                user.photoUrl!,
                                width: XSizes.d100,
                                height: XSizes.d100,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.person, size: XSizes.d100),
                      ),
                      const SizedBox(height: XSizes.d24),
                      Text(
                        XTextStrings.profileTitle,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: XSizes.d16),
                      InfoField(label: XTextStrings.authName, value: user.name),
                      const SizedBox(height: XSizes.d12),
                      InfoField(
                        label: XTextStrings.authEmail,
                        value: user.email,
                      ),
                      const SizedBox(height: XSizes.d32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<AuthBloc>().add(AuthLogoutEvent());
                          },
                          icon: const Icon(Icons.logout),
                          label: const Text(XTextStrings.profileLogout),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
