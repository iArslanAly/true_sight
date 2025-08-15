import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static final Map<Permission, String> _permissionLabels = {
    Permission.camera: 'Camera',
    Permission.microphone: 'Microphone',
    Permission.audio: 'Audio',
    Permission.photos: 'Photos',
    Permission.mediaLibrary: 'Media Library',
    Permission.phone: 'Phone',
    Permission.sms: 'SMS',
    Permission.location: 'Location',
    Permission.contacts: 'Contacts',
    Permission.manageExternalStorage: 'Storage',
    Permission.videos: 'Videos',
  };

  static final Map<Permission, int> _denialCount = {};

  /// Request multiple permissions and return success/failure.
  static Future<bool> requestPermissions(List<Permission> permissions) async {
    final results = await Future.wait(
      permissions.map((permission) => handlePermission(permission)),
    );

    return results.every((granted) => granted);
  }

  /// General request for all media-related permissions
  static Future<bool> requestAllMediaPermissions() async {
    return await requestPermissions([
      Permission.camera,
      Permission.microphone,
      Permission.audio,
      Permission.photos,
      Permission.mediaLibrary,
      Permission.manageExternalStorage,
      Permission.videos,
    ]);
  }

  /// Request and handle a specific permission
  static Future<bool> handlePermission(Permission permission) async {
    final label = _permissionLabels[permission] ?? permission.toString();

    try {
      if (_isUnsupported(permission)) {
        _log('⚠️ [$label] is not supported on this platform.');
        return false;
      }

      if (await permission.isGranted) {
        _denialCount[permission] = 0;
        _log('$label already granted.');
        return true;
      }

      if (await permission.isPermanentlyDenied ||
          await permission.isRestricted) {
        _denialCount[permission] = 3;
        _log('$label is permanently denied or restricted. Opening settings...');

        return false;
      }

      final status = await permission.request();

      if (status.isGranted) {
        _denialCount[permission] = 0;
        _log('$label granted.');
        return true;
      } else {
        _denialCount[permission] = (_denialCount[permission] ?? 0) + 1;
        _log('$label denied (${_denialCount[permission]}x)');
        return false;
      }
    } catch (e, stackTrace) {
      _log('❌ Exception requesting $label: $e');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    }
  }

  /// Request individual permissions
  static Future<bool> requestPhonePermission() =>
      handlePermission(Permission.phone);

  static Future<bool> requestSmsPermission() =>
      handlePermission(Permission.sms);

  static Future<bool> requestContactPermission() =>
      handlePermission(Permission.contacts);

  static Future<bool> requestLocationPermission() =>
      handlePermission(Permission.location);

  static Future<bool> requestStoragePermission() =>
      handlePermission(Permission.manageExternalStorage);
  static Future<bool> requestCameraPermission() =>
      handlePermission(Permission.camera);
  static Future<bool> requestMicrophonePermission() =>
      handlePermission(Permission.microphone);
  static Future<bool> requestAudioPermission() =>
      handlePermission(Permission.audio);
  static Future<bool> requestPhotosPermission() =>
      handlePermission(Permission.photos);
  static Future<bool> requestMediaLibraryPermission() =>
      handlePermission(Permission.mediaLibrary);
  static Future<bool> requestVideosPermission() =>
      handlePermission(Permission.videos);

  /// Determine if we should prompt user to open app settings
  static bool shouldSuggestSettings(Permission permission) {
    return (_denialCount[permission] ?? 0) >= 3;
  }

  /// Open app settings if permission is denied multiple times
  static Future<void> openSettingsIfDenied(Permission permission) async {
    if (shouldSuggestSettings(permission)) {
      await openAppSettings();
    }
  }

  /// Returns true if any of the given permissions have reached denial threshold
  static bool shouldSuggestSettingsForAny(List<Permission> permissions) {
    return permissions.any((permission) => shouldSuggestSettings(permission));
  }

  /// Platform-specific unsupported permission check
  static bool _isUnsupported(Permission permission) {
    if (Platform.isIOS) {
      return permission == Permission.manageExternalStorage ||
          permission == Permission.sms;
    }
    if (Platform.isAndroid) {
      return permission == Permission.mediaLibrary;
    }
    return false;
  }

  /// Central logging
  static void _log(String message) {
    debugPrint('[PermissionUtils] $message');
  }
}
