import Flutter
import UIKit

public class SwiftFlutterPlugin: NSObject, FlutterPlugin {
  var registrar: FlutterPluginRegistrar?

  var guardian: GuardianFlutter?
  var device: GuardianDeviceFlutter?

  /// Initialize the plugin with the Flutter engine.
  public init(with registrar: FlutterPluginRegistrar) {
    super.init()
    self.registrar = registrar

    // Initialize plugin components.
    guardian = GuardianFlutter(plugin: self)
    device = GuardianDeviceFlutter(plugin: self)
  }

  /// Register the plugin with the Flutter engine.
  public static func register(with registrar: FlutterPluginRegistrar) {
    let _ = SwiftFlutterPlugin(with: registrar)
  }

  /// Detach the plugin from the Flutter engine.
  public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
    guardian?.dispose()
    guardian = nil
    device?.dispose()
    device = nil
  }
}
