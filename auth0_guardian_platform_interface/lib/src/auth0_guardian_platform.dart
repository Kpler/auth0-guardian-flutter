import 'package:auth0_guardian_platform_interface/src/device.dart';
import 'package:auth0_guardian_platform_interface/src/guardian.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class Auth0GuardianPlatform extends PlatformInterface {
  /// Creates a new [Auth0GuardianPlatform].
  Auth0GuardianPlatform() : super(token: _token);

  static final Object _token = Object();

  static Auth0GuardianPlatform? _instance;

  /// The instance of [Auth0GuardianPlatform] to use.
  static Auth0GuardianPlatform? get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [Auth0GuardianPlatform] when they register themselves.
  static set instance(Auth0GuardianPlatform? instance) {
    if (instance == null) {
      throw AssertionError(
        'Platform interfaces can only be set to a non-null instance',
      );
    }
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Creates a new [PlatformGuardian].
  ///
  /// This function should only be called by the app-facing package.
  /// Look at using [PlatformGuardian] in `auth0_guardian` instead.
  PlatformGuardian createPlatformGuardian(
    PlatformGuardianCreationParams params,
  ) {
    throw UnimplementedError(
      'createPlatformGuardian is not implemented on the current platform.',
    );
  }

  /// Creates a new [PlatformDevice].
  ///
  /// This function should only be called by the app-facing package.
  /// Look at using [PlatformDevice] in `auth0_guardian` instead.
  PlatformDevice createPlatformDevice(
    PlatformDeviceCreationParams params,
  ) {
    throw UnimplementedError(
      'createPlatformDevice is not implemented on the current platform.',
    );
  }
}
