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
      updatePassword: sl(),
      getLoggedInUser: sl(),
      updateProfileImage: sl(),
      updateProfile: sl(),
    ),
  );
  sl.registerFactory(
    () => DetectionBloc(
      getDetectionResult: sl(),
      getDetectionResultHistory: sl(),
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
  sl.registerLazySingleton(() => UpdatePassword(sl()));
  sl.registerLazySingleton(() => GetLoggedInUser(sl()));
  sl.registerLazySingleton(() => UpdateProfileImage(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerLazySingleton(() => GetDetectionResult(sl()));
  sl.registerLazySingleton(() => GetDetectionResultHistory(sl()));

  /// Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<DetectionRepository>(
    () => DetectionRepositoryImpl(sl()),
  );

  ///! Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      googleSignIn: sl(),
      connectivity: sl(),
      firebaseStorage: sl(),
    ),
  );
  sl.registerLazySingleton<DetectionRemoteDataSource>(
    () => DetectionRemoteDataSourceImpl(sl<DioClient>()),
  );

  //! External dependencies
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn.instance);
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton<DioClient>(() => DioClient.instance);
}
