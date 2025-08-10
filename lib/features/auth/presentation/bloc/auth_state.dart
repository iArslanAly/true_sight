part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState({
    this.status = const AuthInitial(),
    this.email = '',
    this.user,
  });

  final AuthStatus
  status; // e.g., AuthInitial, AuthLoading, Authenticated, AuthError
  final String email;
  final UserEntity? user;

  @override
  List<Object?> get props => [status, email, user];

  AuthState copyWith({AuthStatus? status, String? email, UserEntity? user}) {
    return AuthState(
      status: status ?? this.status,

      email: email ?? this.email,
      user: user ?? this.user,
    );
  }
}
