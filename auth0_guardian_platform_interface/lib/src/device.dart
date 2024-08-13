import 'package:auth0_guardian_platform_interface/auth0_guardian_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// Object specifying creation parameters for creating a [PlatformDevice].
///
/// Platform specific implementations can add additional fields by extending
/// this class.
@immutable
class PlatformDeviceCreationParams {
  /// A previously enrolled device.
  final EnrolledDevice device;

  /// The domain of the auth0 account to use.
  final String domain;

  /// Used by the platform implementation to create a new [PlatformDevice].
  const PlatformDeviceCreationParams({
    required this.device,
    required this.domain,
  });
}

abstract class PlatformDevice extends PlatformInterface {
  /// Creates a new [PlatformDevice]
  factory PlatformDevice(PlatformDeviceCreationParams params) {
    assert(
      Auth0GuardianPlatform.instance != null,
      'A platform implementation for `auth0_guardian` has not been set. Please '
      'ensure that an implementation of `Auth0GuardianPlatform` has been set to '
      '`WebViewPlatform.instance` before use. For unit testing, '
      '`WebViewPlatform.instance` can be set with your own test implementation.',
    );
    final plugin = Auth0GuardianPlatform.instance!;
    final guardian = plugin.createPlatformDevice(params);
    PlatformInterface.verify(guardian, _token);
    return guardian;
  }

  /// Used by the platform implementation to create a new [PlatformGuardian].
  ///
  /// Should only be used by platform implementations because they can't extend
  /// a class that only contains a factory constructor.
  @protected
  PlatformDevice.implementation(this.params) : super(token: _token);

  static final Object _token = Object();

  /// The parameters used to initialize the [PlatformGuardian].
  final PlatformDeviceCreationParams params;

  /// {@template auth0_guardian_platform_interface.PlatformDevice.delete}
  /// Unenrolls the current device to auth0.
  /// {@endtemplate}
  Future<bool> delete() async {
    throw UnimplementedError(
      'delete is not implemented on the current platform.',
    );
  }

  /// {@template auth0_guardian_platform_interface.PlatformDevice.delete}
  /// Unenrolls the current device to auth0.
  /// {@endtemplate}
  Future<bool> update({
    String? name,
    String? notificationToken,
    String? localIdentifier,
  }) async {
    throw UnimplementedError(
      'update is not implemented on the current platform.',
    );
  }
}
