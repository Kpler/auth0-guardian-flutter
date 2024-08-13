import Flutter
import Foundation
import Guardian

/// Generates an error message for the error printed / logged by the plugin.
public func getGuardianErrorMessage(_ message: String) -> String {
  return "[Swift - Auth0Guardian] \(message)"
}

/// Generates a FlutterError that will be sent to the flutter side.
public func getGuardianFlutterError(_ error: Error, _ message: String) -> FlutterError {
  return FlutterError(
    code: getGuardianErrorCode(error),
    message: getGuardianErrorMessage(message),
    details: error.localizedDescription
  )
}

/// Generates an error code for the error printed / logged by the plugin.
public func getGuardianErrorCode(_ error: Error) -> String {
  let errorCode: String
  switch error {
  case is GuardianError:
    errorCode = (error as! GuardianError).code
  case is NetworkError:
    errorCode = (error as! NetworkError).code.rawValue
  default:
    errorCode = "UnknownCode"
  }
  return errorCode
}
