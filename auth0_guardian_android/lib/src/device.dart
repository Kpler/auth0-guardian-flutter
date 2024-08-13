import 'package:auth0_guardian_platform_interface/auth0_guardian_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Object specifying creation parameters for creating a [AndroidDevice].
///
/// When adding additional fields make sure they can be null or have a default
/// value to avoid breaking changes. See [PlatformDeviceCreationParams] for
/// more information.
@immutable
class AndroidDeviceCreationParams extends PlatformDeviceCreationParams {
  /// Creates a new [AndroidDeviceCreationParams] instance.
  AndroidDeviceCreationParams(
    // This parameter prevents breaking changes later.
    // ignore: avoid_unused_constructor_parameters
    PlatformDeviceCreationParams params,
  ) : super(device: params.device, domain: params.domain);

  /// Creates a [AndroidDeviceCreationParams] instance based on [PlatformDeviceCreationParams].
  factory AndroidDeviceCreationParams.fromPlatformDeviceCreationParams(
    PlatformDeviceCreationParams params,
  ) {
    return AndroidDeviceCreationParams(params);
  }
}

class AndroidDevice extends PlatformDevice {
  /// Creates a new [AndroidDevice].
  AndroidDevice(super.params) : super.implementation();

  @visibleForTesting
  final methodChannel = const MethodChannel(
    'com.kpler/auth0_guardian_android/device',
  );

  @override
  Future<bool> delete() async {
    final result = await methodChannel.invokeMethod<bool>('delete', {
      'forDomain': params.domain,
      'forEnrollmentId': params.device.id,
      'userId': params.device.userId,
    });
    return result!;
  }
}
