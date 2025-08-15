part of 'permission_cubit.dart';

abstract class PermissionState extends Equatable {
  const PermissionState();
  @override
  List<Object?> get props => [];
}

class PermissionInitial extends PermissionState {}

class PermissionLoading extends PermissionState {}

class PermissionGranted extends PermissionState {
  final Permission permission;
  const PermissionGranted(this.permission);

  @override
  List<Object?> get props => [permission];
}

class PermissionDenied extends PermissionState {
  final Permission permission;
  const PermissionDenied(this.permission);

  @override
  List<Object?> get props => [permission];
}

class PermissionSuggestSettings extends PermissionState {
  final Permission permission;
  const PermissionSuggestSettings(this.permission);

  @override
  List<Object?> get props => [permission];
}
