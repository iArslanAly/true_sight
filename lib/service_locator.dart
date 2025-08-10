import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:true_sight/features/auth/data/datasource/auth_remote_data_source_impl.dart';
import 'package:true_sight/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:true_sight/features/auth/domain/repositories/auth_repository.dart';
import 'package:true_sight/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:true_sight/features/auth/domain/usecases/user_login.dart';
import 'package:true_sight/features/auth/domain/usecases/user_logout.dart';
import 'package:true_sight/features/auth/domain/usecases/user_signup.dart';

import 'features/auth/data/datasource/auth_remote_data_source.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

part 'service_locator.main.dart';
