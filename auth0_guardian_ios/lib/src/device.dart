import 'package:auth0_guardian_platform_interface/auth0_guardian_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Object specifying creation parameters for creating a [IosDevice].
///
/// When adding additional fields make sure they can be null or have a default
/// value to avoid breaking changes. See [PlatformDeviceCreationParams] for
/// more information.
@immutable
class IosDeviceCreationParams extends PlatformDeviceCreationParams {
  /// Creates a new [IosDeviceCreationParams] instance.
  IosDeviceCreationParams(
    // This parameter prevents breaking changes later.
    // ignore: avoid_unused_constructor_parameters
    PlatformDeviceCreationParams params,
  ) : super(device: params.device, domain: params.domain);

  /// Creates a [IosDeviceCreationParams] instance based on [PlatformDeviceCreationParams].
  factory IosDeviceCreationParams.fromPlatformDeviceCreationParams(
    PlatformDeviceCreationParams params,
  ) {
    return IosDeviceCreationParams(params);
  }
}

class IosDevice extends PlatformDevice {
  /// Creates a new [IosDevice].
  IosDevice(super.params) : super.implementation();

  @visibleForTesting
  final methodChannel = const MethodChannel(
    'com.kpler/auth0_guardian_ios/device',
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

  @override
  Future<bool> update({
    String? name,
    String? notificationToken,
    String? localIdentifier,
  }) async {
    final result = await methodChannel.invokeMethod<bool>('update', {
      'forDomain': params.domain,
      'forEnrollmentId': params.device.id,
      'userId': params.device.userId,
      'name': name,
      'notificationToken': notificationToken,
      'localIdentifier': localIdentifier,
    });
    return result ?? false;
  }
}
