/// A Guardian enrolled device.
class EnrolledDevice {
  EnrolledDevice({
    required this.id,
    required this.deviceToken,
    required this.userId,
    this.notificationToken,
    this.totp,
  });

  /// The enrolled device id from Guardian.
  final String id;

  /// The id of the user associated to this device.
  final String? userId;

  /// The token used to authenticate when updating the device data or deleting it.
  final String deviceToken;

  /// The APNs token for this physical device, required to check against the
  /// current token and update the server in case it's not the same.
  /// important: Needs to be kept up-to-date on the server for the push notifications to work.
  final String? notificationToken;

  /// The TOTP parameters associated to the device
  /// important: Might be nil if TOTP mode is disabled
  final OTPParameters? totp;

  /// Creates an [EnrolledDevice] from a JSON map.
  factory EnrolledDevice.fromJson(Map<String, dynamic> map) {
    return EnrolledDevice(
      id: map['id'],
      userId: map['userId'],
      deviceToken: map['deviceToken'],
      notificationToken: map['notificationToken'],
      totp: map['totp'] != null
          ? OTPParameters.fromJson(
              Map<String, dynamic>.from(map['totp'] as Map),
            )
          : null,
    );
  }
}

/// The algorithm used to generate the HMAC.
enum HMACAlgorithm { sha1, sha256, sha512 }

/// Parameters for OTP codes.
class OTPParameters {
  /// The TOTP secret, Base32 encoded
  final String base32Secret;

  /// The TOTP algorithm
  final HMACAlgorithm algorithm;

  /// The TOTP digits, i.e. the code length. Default is 6 digits
  final int digits;

  /// The TOTP period, in seconds. Default is 30 seconds
  final int period;

  OTPParameters({
    required this.base32Secret,
    this.algorithm = HMACAlgorithm.sha1,
    this.digits = 6,
    this.period = 30,
  });

  /// Creates the parameters from a JSON map.
  factory OTPParameters.fromJson(Map<String, dynamic> map) {
    return OTPParameters(
      base32Secret: map['base32Secret'] as String,
      algorithm: HMACAlgorithm.values.asNameMap()[map['algorithm']]!,
      digits: map['digits'] as int,
      period: map['period'] as int,
    );
  }

  /// Converts the parameters to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'base32Secret': base32Secret,
      'algorithm': algorithm.name,
      'digits': digits,
      'period': period,
    };
  }
}
