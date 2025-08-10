import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/core/utils/status/auth_status.dart';
import 'package:true_sight/core/utils/status/usecases.dart';
import 'package:true_sight/features/auth/domain/entities/user_entity.dart';
import 'package:true_sight/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:true_sight/features/auth/domain/usecases/user_login.dart';
import 'package:true_sight/features/auth/domain/usecases/user_logout.dart';
import 'package:true_sight/features/auth/domain/usecases/user_signup.dart';
import 'package:true_sight/features/auth/presentation/bloc/auth_bloc.dart';

// ===== Mock classes =====
class MockLoginUser extends Mock implements LoginUser {}

class MockSignupUser extends Mock implements SignupUser {}

class MockSignInWithGoogle extends Mock implements SignInWithGoogle {}

class MockUserLogout extends Mock implements UserLogout {}

// ===== Fake parameter classes for mocktail fallback values =====
class FakeLoginUserParams extends Fake implements LoginUserParams {}

class FakeSignupParams extends Fake implements SignupParams {}

class FakeNoParams extends Fake implements NoParams {}

void main() {
  late MockLoginUser mockLoginUser;
  late MockSignupUser mockSignupUser;
  late MockSignInWithGoogle mockSignInWithGoogle;
  late MockUserLogout mockUserLogout;
  late AuthBloc authBloc;

  const testUser = UserEntity(
    uid: '123',
    email: 'test@example.com',
    name: 'Test User',
    emailVerified: true,
    provider: '',
  );

  setUpAll(() {
    registerFallbackValue(FakeLoginUserParams());
    registerFallbackValue(FakeSignupParams());
    registerFallbackValue(FakeNoParams());
  });

  setUp(() {
    mockLoginUser = MockLoginUser();
    mockSignupUser = MockSignupUser();
    mockSignInWithGoogle = MockSignInWithGoogle();
    mockUserLogout = MockUserLogout();

    authBloc = AuthBloc(
      loginUser: mockLoginUser,
      signupUser: mockSignupUser,
      signInWithGoogle: mockSignInWithGoogle,
      userLogout: mockUserLogout,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthLoginEvent', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when login succeeds',
      build: () {
        when(
          () => mockLoginUser(any()),
        ).thenAnswer((_) async => const Right(testUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        AuthLoginEvent(email: 'test@example.com', password: '123456'),
      ),
      expect: () => [
        isA<AuthState>().having((s) => s.status, 'status', isA<AuthLoading>()),
        isA<AuthState>()
            .having((s) => s.status, 'status', isA<AuthSuccess>())
            .having((s) => s.email, 'email', 'test@example.com')
            .having((s) => s.user, 'user', testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when login fails',
      build: () {
        // Use a concrete Failure instance from your project
        when(
          () => mockLoginUser(any()),
        ).thenAnswer((_) async => Left(NetworkFailure()));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginEvent(email: 'wrong@example.com', password: '123456'),
      ),
      expect: () => [
        isA<AuthState>().having((s) => s.status, 'status', isA<AuthLoading>()),
        // Only assert that status is AuthFailure (don't assert message string here)
        isA<AuthState>().having((s) => s.status, 'status', isA<AuthFailure>()),
      ],
    );
  });

  group('AuthGoogleLoginEvent', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] on Google login success',
      build: () {
        when(
          () => mockSignInWithGoogle(any()),
        ).thenAnswer((_) async => const Right(testUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthGoogleLoginEvent()),
      expect: () => [
        isA<AuthState>().having((s) => s.status, 'status', isA<AuthLoading>()),
        isA<AuthState>()
            .having((s) => s.status, 'status', isA<AuthSuccess>())
            .having((s) => s.email, 'email', testUser.email)
            .having((s) => s.user, 'user', testUser),
      ],
    );
  });

  group('AuthLogoutEvent', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess(message: logged out)] on logout success',
      build: () {
        when(
          () => mockUserLogout(any()),
        ).thenAnswer((_) async => const Right(true));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthLogoutEvent()),
      expect: () => [
        isA<AuthState>().having((s) => s.status, 'status', isA<AuthLoading>()),
        isA<AuthState>().having((s) => s.status, 'status', isA<AuthSuccess>()),
      ],
    );
  });
}
