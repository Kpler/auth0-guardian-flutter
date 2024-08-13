import 'package:auth0_guardian_ios/auth0_guardian_ios.dart';
import 'package:auth0_guardian_ios/src/device.dart';
import 'package:auth0_guardian_platform_interface/auth0_guardian_platform_interface.dart';

class IosAuth0GuardianPlatform extends Auth0GuardianPlatform {
  /// Registers this class as the default instance of [Auth0GuardianPlatform].
  static void registerWith() {
    Auth0GuardianPlatform.instance = IosAuth0GuardianPlatform();
  }

  /// Creates a new [IosGuardian].
  ///
  /// This function should only be called by the app-facing package.
  /// Look at using [Guardian] in `auth0_guardian` instead.
  @override
  IosGuardian createPlatformGuardian(PlatformGuardianCreationParams params) {
    return IosGuardian(params);
  }

  /// Creates a new [IosDevice].
  ///
  /// This function should only be called by the app-facing package.
  /// Look at using [Device] in `auth0_guardian` instead.
  @override
  IosDevice createPlatformDevice(PlatformDeviceCreationParams params) {
    return IosDevice(params);
  }
}
