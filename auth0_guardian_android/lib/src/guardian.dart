import 'package:auth0_guardian_platform_interface/auth0_guardian_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Object specifying creation parameters for creating a [AndroidGuardian].
///
/// When adding additional fields make sure they can be null or have a default
/// value to avoid breaking changes. See [PlatformGuardianCreationParams] for
/// more information.
@immutable
class AndroidGuardianCreationParams extends PlatformGuardianCreationParams {
  /// Creates a new [AndroidGuardianCreationParams] instance.
  AndroidGuardianCreationParams(
    // This parameter prevents breaking changes later.
    // ignore: avoid_unused_constructor_parameters
    PlatformGuardianCreationParams params,
  ) : super(tenantUrl: params.tenantUrl);

  /// Creates a [AndroidGuardianCreationParams] instance based on [PlatformGuardianCreationParams].
  factory AndroidGuardianCreationParams.fromPlatformGuardianCreationParams(
      PlatformGuardianCreationParams params) {
    return AndroidGuardianCreationParams(params);
  }
}

class AndroidGuardian extends PlatformGuardian {
  /// Creates a new [AndroidGuardian].
  AndroidGuardian(super.params) : super.implementation();

  @visibleForTesting
  final methodChannel = const MethodChannel(
    'com.kpler/auth0_guardian_android/guardian',
  );

  @override
  Future<EnrolledDevice> enroll({
    required String usingUri,
    required String notificationToken,
  }) async {
    final result = await methodChannel.invokeMethod<Map>('enroll', {
      'forDomain': params.tenantUrl,
      'usingUri': usingUri,
      'notificationToken': notificationToken,
    });
    return EnrolledDevice.fromJson(Map<String, dynamic>.from(result as Map));
  }

  @override
  Future<bool> acceptRequest({required Map notification}) async {
    final result = await methodChannel.invokeMethod<bool>('acceptRequest', {
      'forDomain': params.tenantUrl,
      'notification': notification,
    });
    return result!;
  }

  @override
  Future<bool> rejectRequest({
    required Map notification,
    String? reason,
  }) async {
    final result = await methodChannel.invokeMethod<bool>('rejectRequest', {
      'forDomain': params.tenantUrl,
      'notification': notification,
      'withReason': reason,
    });
    return result ?? false;
  }

  @override
  Future<bool> isGuardianNotification(Map notification) async {
    final result = await methodChannel.invokeMethod<bool>(
      'isGuardianNotification',
      {'notification': notification},
    );
    return result ?? false;
  }
}
