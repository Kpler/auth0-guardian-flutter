import Flutter
import Foundation
import Guardian

public class GuardianDeviceFlutter: NSObject {
  static let METHOD_CHANNEL_NAME = "com.kpler/auth0_guardian_ios/device"

  var plugin: SwiftFlutterPlugin?

  init(plugin: SwiftFlutterPlugin) {
    super.init()
    self.plugin = plugin
    let channel = FlutterMethodChannel(
      name: GuardianDeviceFlutter.METHOD_CHANNEL_NAME,
      binaryMessenger: plugin.registrar!.messenger()
    )
    channel.setMethodCallHandler(handle(_:result:))
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as? NSDictionary
    let args = call.arguments as! [String: Any]

    switch call.method {
    case "delete":
      delete(args: args, result: result)
    case "update":
      update(args: args, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  public func delete(args: [String: Any], result: @escaping FlutterResult) {
    do {
      // Extract the arguments from the method call (Flutter).
      let forDomain = args["forDomain"] as! String
      let forEnrollmentId = args["forEnrollmentId"] as! String
      let userId = args["userId"] as! String

      // Get the signing key and the verification key.
      let signingKey = try SigningKeyService(domain: forDomain).getSigningKey()

      // Trigger the deletion.
      Guardian
        .api(forDomain: forDomain)
        .device(forEnrollmentId: forEnrollmentId, userId: userId, signingKey: signingKey)
        .delete()
        .start { response in
          switch response {
          case .success:
            result(true)
          case .failure(let error):
            result(
              getGuardianFlutterError(error, "DeviceFlutter.delete() deleting failed")
            )
          }
        }
    } catch (let error) {
      result(
        getGuardianFlutterError(error, "DeviceFlutter.delete() throwed an unexpected error")
      )
    }
  }

  public func update(args: [String: Any], result: @escaping FlutterResult) {
    do {
      // Extract the arguments from the method call (Flutter).
      let forDomain = args["forDomain"] as! String
      let forEnrollmentId = args["forEnrollmentId"] as! String
      let userId = args["userId"] as! String

      let localIdentifier = args["localIdentifier"] as? String? ?? nil
      let name = args["name"] as? String? ?? nil
      let notificationToken = args["notificationToken"] as? String? ?? nil

      // Get the signing key and the verification key.
      let signingKey = try SigningKeyService(domain: forDomain).getSigningKey()

      // Trigger the deletion.
      Guardian
        .api(forDomain: forDomain)
        .device(forEnrollmentId: forEnrollmentId, userId: userId, signingKey: signingKey)
        .update(localIdentifier: localIdentifier, name: name, notificationToken: notificationToken)
        .start { response in
          switch response {
          case .success:
            result(true)
          case .failure(let error):
            result(
              getGuardianFlutterError(error, "DeviceFlutter.update() updating failed")
            )
          }
        }
    } catch (let error) {
      result(
        getGuardianFlutterError(error, "DeviceFlutter.update() throwed an unexpected error")
      )
    }
  }

  public func dispose() {
    plugin = nil
  }

  deinit {
    dispose()
  }
}
