part of 'service_locator.dart';

final sl = GetIt.instance;
Future<void> init() async {
  /// Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUser: sl(),
      signupUser: sl(),
      signInWithGoogle: sl(),
      userLogout: sl(),
      resendVerificationEmail: sl(),
      sendOtp: sl(),
      verifyOtp: sl(),
    ),
  );

  /// Use Cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => SignupUser(sl()));
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => UserLogout(sl()));
  sl.registerLazySingleton(() => ResendVerificationEmail(sl()));
  sl.registerLazySingleton(() => SendOtp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  

  /// Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  ///! Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      googleSignIn: sl(),
    ),
  );

  //! External dependencies
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn.instance);
}
