import Flutter
import Foundation
import Guardian

public class GuardianFlutter: NSObject {
  static let METHOD_CHANNEL_NAME = "com.kpler/auth0_guardian_ios/guardian"

  var plugin: SwiftFlutterPlugin?

  init(plugin: SwiftFlutterPlugin) {
    super.init()
    self.plugin = plugin
    let channel = FlutterMethodChannel(
      name: GuardianFlutter.METHOD_CHANNEL_NAME,
      binaryMessenger: plugin.registrar!.messenger()
    )
    channel.setMethodCallHandler(handle(_:result:))
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as? NSDictionary
    let args = call.arguments as! [String: Any]

    switch call.method {
    case "enroll":
      enroll(args: args, result: result)
    case "acceptRequest":
      acceptRequest(args: args, result: result)
    case "rejectRequest":
      rejectRequest(args: args, result: result)
    case "isGuardianNotification":
      isGuardianNotification(args: args, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  public func enroll(args: [String: Any], result: @escaping FlutterResult) {
    do {
      // Extract the arguments from the method call (Flutter).
      let forDomain = args["forDomain"] as! String
      let usingUri = args["usingUri"] as! String
      let notificationToken = args["notificationToken"] as! String

      // Get the signing key and the verification key.
      let signingKey = try SigningKeyService(domain: forDomain).getSigningKey()
      let verificationKey = try signingKey.verificationKey()

      // Trigger the enrollment.
      Guardian.enroll(
        forDomain: forDomain,
        usingUri: usingUri,
        notificationToken: notificationToken,
        signingKey: signingKey,
        verificationKey: verificationKey
      ).start { response in
        switch response {
        case .success(let enrollment):
          result(enrollment.toFlutterResult())
          return
        case .failure(let error):
          result(
            getGuardianFlutterError(error, "GuardianFlutter.enroll() enrollment failed")
          )
          return
        }
      }
    } catch (let error) {
      result(
        getGuardianFlutterError(error, "GuardianFlutter.enroll() thrown an unexpected error")
      )
    }
  }

  public func acceptRequest(args: [String: Any], result: @escaping FlutterResult) {
    do {
      // Extract the arguments from the method call (Flutter).
      let payload = args["notification"] as! [AnyHashable: Any]
      let forDomain = args["forDomain"] as! String

      // Generate the notification object from the push payload.
      let notification = Guardian.notification(from: payload)

      // Get the signing key and the verification key.
      let signingKey = try SigningKeyService(domain: forDomain).getSigningKey()

      // Trigger the authentication request acceptance.
      Guardian
        .authentication(forDomain: forDomain, device: signingKey.getDevice())
        .allow(notification: notification!)
        .start { response in
          switch response {
          case .success:
            result(true)
            return
          case .failure(let error):
            result(
              getGuardianFlutterError(error, "GuardianFlutter.acceptRequest() failed")
            )
            return
          }
        }
    } catch (let error) {
      result(
        getGuardianFlutterError(
          error, "GuardianFlutter.acceptRequest() throwed an unexpected error"
        )
      )
    }
  }

  public func rejectRequest(args: [String: Any], result: @escaping FlutterResult) {
    do {
      // Extract the arguments from the method call (Flutter).
      let payload = args["notification"] as! [AnyHashable: Any]
      let withReason = args["withReason"] as? String? ?? nil
      let forDomain = args["forDomain"] as! String

      // Generate the notification object from the push payload.
      let notification = Guardian.notification(from: payload)

      // Get the signing key and the verification key.
      let signingKey = try SigningKeyService(domain: forDomain).getSigningKey()

      // Trigger the authentication request acceptance.
      Guardian
        .authentication(forDomain: forDomain, device: signingKey.getDevice())
        .reject(notification: notification!, withReason: withReason)
        .start { response in
          switch response {
          case .success:
            result(true)
            return
          case .failure(let error):
            result(
              getGuardianFlutterError(error, "GuardianFlutter.rejectRequest() failed")
            )
            return
          }
        }
    } catch (let error) {
      result(
        getGuardianFlutterError(
          error, "GuardianFlutter.rejectRequest() throwed an unexpected error"
        )
      )
    }
  }

  public func isGuardianNotification(args: [String: Any], result: @escaping FlutterResult) {
    let payload = args["notification"] as! [AnyHashable: Any]
    let notification = Guardian.notification(from: payload)
    result(notification != nil)
  }

  public func dispose() {
    plugin = nil
  }

  deinit {
    dispose()
  }
}
