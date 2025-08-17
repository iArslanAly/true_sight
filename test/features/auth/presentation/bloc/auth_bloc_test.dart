import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/core/utils/status/auth_status.dart';
import 'package:true_sight/core/utils/usecase/usecases.dart';
import 'package:true_sight/features/auth/domain/entities/user_entity.dart';
import 'package:true_sight/features/auth/domain/usecases/get_logged_in_user.dart';
import 'package:true_sight/features/auth/domain/usecases/is_email_verified.dart';
import 'package:true_sight/features/auth/domain/usecases/resend_verification_email.dart';
import 'package:true_sight/features/auth/domain/usecases/send_otp.dart';
import 'package:true_sight/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:true_sight/features/auth/domain/usecases/update_password.dart';
import 'package:true_sight/features/auth/domain/usecases/update_profile_image.dart';
import 'package:true_sight/features/auth/domain/usecases/update_user.dart';
import 'package:true_sight/features/auth/domain/usecases/user_login.dart';
import 'package:true_sight/features/auth/domain/usecases/user_logout.dart';
import 'package:true_sight/features/auth/domain/usecases/user_signup.dart';
import 'package:true_sight/features/auth/domain/usecases/verify_otp.dart';
import 'package:true_sight/features/auth/presentation/bloc/auth_bloc.dart';

// ===== Mock classes =====
class MockLoginUser extends Mock implements LoginUser {}

class MockSignupUser extends Mock implements SignupUser {}

class MockSignInWithGoogle extends Mock implements SignInWithGoogle {}

class MockUserLogout extends Mock implements UserLogout {}

class MockIsEmailVerified extends Mock implements IsEmailVerified {}

class MockSendOtp extends Mock implements SendOtp {}

class MockGetLoggedInUser extends Mock implements GetLoggedInUser {}

class MockUpdateProfile extends Mock implements UpdateProfile {}

class MockResendVerificationEmail extends Mock
    implements ResendVerificationEmail {}

class MockVerifyOtp extends Mock implements VerifyOtp {}

class MockUpdatePassword extends Mock implements UpdatePassword {}

class MockUpdateProfileImage extends Mock implements UpdateProfileImage {}

// ===== Fake parameter classes for mocktail fallback values =====
class FakeLoginUserParams extends Fake implements LoginUserParams {}

class FakeSignupParams extends Fake implements SignupParams {}

class FakeNoParams extends Fake implements NoParams {}

void main() {
  late MockLoginUser mockLoginUser;
  late MockSignupUser mockSignupUser;
  late MockSignInWithGoogle mockSignInWithGoogle;
  late MockUserLogout mockUserLogout;
  late MockResendVerificationEmail mockResendVerificationEmail;
  late MockSendOtp mockSendOtp;
  late AuthBloc authBloc;
  late MockVerifyOtp mockVerifyOtp;
  late MockUpdatePassword mockUpdatePassword;
  late MockGetLoggedInUser mockGetLoggedInUser;
  late MockUpdateProfileImage mockUpdateProfileImage;
  late MockUpdateProfile mockUpdateProfile;

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
    mockResendVerificationEmail = MockResendVerificationEmail();
    mockSendOtp = MockSendOtp();
    mockVerifyOtp = MockVerifyOtp();
    mockUpdatePassword = MockUpdatePassword();
    mockGetLoggedInUser = MockGetLoggedInUser();
    mockUpdateProfileImage = MockUpdateProfileImage();
    mockUpdateProfile = MockUpdateProfile();

    authBloc = AuthBloc(
      loginUser: mockLoginUser,
      signupUser: mockSignupUser,
      signInWithGoogle: mockSignInWithGoogle,
      userLogout: mockUserLogout,
      resendVerificationEmail: mockResendVerificationEmail,
      sendOtp: mockSendOtp,
      verifyOtp: mockVerifyOtp,
      updatePassword: mockUpdatePassword,
      getLoggedInUser: mockGetLoggedInUser,
      updateProfileImage: mockUpdateProfileImage,
      updateProfile: mockUpdateProfile,
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
