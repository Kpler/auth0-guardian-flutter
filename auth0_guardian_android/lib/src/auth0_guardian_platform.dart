import 'package:auth0_guardian_android/src/device.dart';
import 'package:auth0_guardian_android/src/guardian.dart';
import 'package:auth0_guardian_platform_interface/auth0_guardian_platform_interface.dart';

class AndroidAuth0GuardianPlatform extends Auth0GuardianPlatform {
  /// Registers this class as the default instance of [Auth0GuardianPlatform].
  static void registerWith() {
    Auth0GuardianPlatform.instance = AndroidAuth0GuardianPlatform();
  }

  /// Creates a new [AndroidGuardian].
  ///
  /// This function should only be called by the app-facing package.
  /// Look at using [Guardian] in `auth0_guardian` instead.
  @override
  AndroidGuardian createPlatformGuardian(
    PlatformGuardianCreationParams params,
  ) {
    return AndroidGuardian(params);
  }

  /// Creates a new [AndroidDevice].
  ///
  /// This function should only be called by the app-facing package.
  /// Look at using [Device] in `auth0_guardian` instead.
  @override
  AndroidDevice createPlatformDevice(PlatformDeviceCreationParams params) {
    return AndroidDevice(params);
  }
}
