import 'package:auth0_guardian_platform_interface/auth0_guardian_platform_interface.dart';

class Guardian {
  /// Main constructor for creating a [Guardian] instance.
  ///
  /// The [tenantUrl] should be the URL of the tenant to use and respect this format:
  /// `https://<YOUR_TENANT>/appliance-mfa`.
  Guardian({
    required String tenantUrl,
  }) : this.fromPlatformCreationParams(
          PlatformGuardianCreationParams(tenantUrl: tenantUrl),
        );

  /// Constructs a [Guardian] from creation params for a specific platform.
  Guardian.fromPlatformCreationParams(
    PlatformGuardianCreationParams params,
  ) : this.fromPlatform(PlatformGuardian(params));

  /// Constructs a [Guardian] from a specific platform implementation.
  Guardian.fromPlatform(this.platform);

  /// Implementation of [PlatformGuardian] for the current platform.
  final PlatformGuardian platform;

  /// {@macro auth0_guardian_platform_interface.PlatformGuardian.enroll}
  Future<EnrolledDevice> enroll({
    required String usingUri,
    required String notificationToken,
  }) async {
    return platform.enroll(
      usingUri: usingUri,
      notificationToken: notificationToken,
    );
  }

  /// {@macro auth0_guardian_platform_interface.PlatformGuardian.acceptRequest}
  Future<bool> acceptRequest({required Map notification}) async {
    return platform.acceptRequest(notification: notification);
  }

  /// {@macro auth0_guardian_platform_interface.PlatformGuardian.rejectRequest}
  Future<bool> rejectRequest({
    required Map notification,
    String? reason,
  }) async {
    return platform.rejectRequest(notification: notification, reason: reason);
  }

  /// {@macro auth0_guardian_platform_interface.PlatformGuardian.isGuardianNotification}
  Future<bool> isGuardianNotification(Map notification) async {
    return platform.isGuardianNotification(notification);
  }

  /// {@macro auth0_guardian_platform_interface.PlatformDevice.delete}
  Future<bool> deleteDevice(EnrolledDevice device) async {
    return await _getDeviceApi(device).delete();
  }

  /// {@macro auth0_guardian_platform_interface.PlatformDevice.update}
  Future<bool> updateDevice(
    EnrolledDevice device, {
    String? name,
    String? notificationToken,
    String? localIdentifier,
  }) async {
    return await _getDeviceApi(device).update(
      name: name,
      notificationToken: notificationToken,
      localIdentifier: localIdentifier,
    );
  }

  /// Returns the platform specific device API for a given device.
  ///
  /// This is used to interact with a specific device.
  PlatformDevice _getDeviceApi(EnrolledDevice device) {
    return Auth0GuardianPlatform.instance!.createPlatformDevice(
      PlatformDeviceCreationParams(
        device: device,
        domain: platform.params.tenantUrl,
      ),
    );
  }
}
