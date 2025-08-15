import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:true_sight/core/utils/permission_utils.dart';

part 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  PermissionCubit() : super(PermissionInitial());

  /// Request any permission (camera, microphone, photos, etc.)
  Future<void> requestPermission(Permission permission) async {
    emit(PermissionLoading());

    final granted = await PermissionUtils.handlePermission(permission);

    if (granted) {
      emit(PermissionGranted(permission));
    } else {
      final suggest = PermissionUtils.shouldSuggestSettings(permission);
      if (suggest) {
        emit(PermissionSuggestSettings(permission));
      } else {
        emit(PermissionDenied(permission));
      }
    }
  }

  void reset() => emit(PermissionInitial());
}
