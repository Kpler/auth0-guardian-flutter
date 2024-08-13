import Foundation
import Guardian

extension EnrolledDevice {
  public func toFlutterResult() -> [String: Any?] {
    return [
      "id": id,
      "userId": userId,
      "deviceToken": deviceToken,
      "notificationToken": notificationToken,
      "totp": totp?.toFlutterResult(),
    ]
  }
}

extension OTPParameters {
  public func toFlutterResult() -> [String: Any] {
    return [
      "base32Secret": base32Secret,
      "algorithm": algorithm.rawValue,
      "digits": digits,
      "period": period,
    ]
  }
}
