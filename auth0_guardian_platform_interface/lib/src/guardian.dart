import 'package:auth0_guardian_platform_interface/auth0_guardian_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// Object specifying creation parameters for creating a [PlatformGuardian].
///
/// Platform specific implementations can add additional fields by extending
/// this class.
@immutable
class PlatformGuardianCreationParams {
  /// The domain of the auth0 account to use.
  final String tenantUrl;

  /// Used by the platform implementation to create a new [PlatformGuardian].
  const PlatformGuardianCreationParams({required this.tenantUrl});
}

abstract class PlatformGuardian extends PlatformInterface {
  /// Creates a new [PlatformGuardian]
  factory PlatformGuardian(PlatformGuardianCreationParams params) {
    assert(
      Auth0GuardianPlatform.instance != null,
      'A platform implementation for `auth0_guardian` has not been set. Please '
      'ensure that an implementation of `Auth0GuardianPlatform` has been set to '
      '`WebViewPlatform.instance` before use. For unit testing, '
      '`WebViewPlatform.instance` can be set with your own test implementation.',
    );
    final plugin = Auth0GuardianPlatform.instance!;
    final guardian = plugin.createPlatformGuardian(params);
    PlatformInterface.verify(guardian, _token);
    return guardian;
  }

  /// Used by the platform implementation to create a new [PlatformGuardian].
  ///
  /// Should only be used by platform implementations because they can't extend
  /// a class that only contains a factory constructor.
  @protected
  PlatformGuardian.implementation(this.params) : super(token: _token);

  static final Object _token = Object();

  /// The parameters used to initialize the [PlatformGuardian].
  final PlatformGuardianCreationParams params;

  /// {@template auth0_guardian_platform_interface.PlatformGuardian.enroll}
  /// Enrolls the current device to auth0.
  /// {@endtemplate}
  Future<EnrolledDevice> enroll({
    required String usingUri,
    required String notificationToken,
  }) async {
    throw UnimplementedError(
      'enroll is not implemented on the current platform.',
    );
  }

  /// {@template auth0_guardian_platform_interface.PlatformGuardian.acceptRequest}
  /// Accepts an auth request from auth0.
  /// {@endtemplate}
  Future<bool> acceptRequest({required Map notification}) async {
    throw UnimplementedError(
      'acceptRequest is not implemented on the current platform.',
    );
  }

  /// {@template auth0_guardian_platform_interface.PlatformGuardian.rejectRequest}
  /// Rejects an auth request from auth0.
  /// {@endtemplate}
  Future<bool> rejectRequest({
    required Map notification,
    String? reason,
  }) async {
    throw UnimplementedError(
      'rejectRequest is not implemented on the current platform.',
    );
  }

  /// {@template auth0_guardian_platform_interface.PlatformGuardian.isGuardianNotification}
  /// Checks if a notification is from guardian.
  /// {@endtemplate}
  Future<bool> isGuardianNotification(Map notification) async {
    throw UnimplementedError(
      'isGuardianNotification is not implemented on the current platform.',
    );
  }
}
