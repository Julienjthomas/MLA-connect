import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let channel = FlutterMethodChannel(
      name: "systems.keyvalue.super_balussery/app_icon",
      binaryMessenger: engineBridge.binaryMessenger
    )
    channel.setMethodCallHandler { call, result in
      guard call.method == "setIcon" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard UIApplication.shared.supportsAlternateIcons else {
        result(FlutterError(code: "UNSUPPORTED", message: "Alternate icons not supported", details: nil))
        return
      }
      let args = call.arguments as? [String: Any?]
      let iconName = args?["icon"] as? String  // nil = default icon
      UIApplication.shared.setAlternateIconName(iconName) { error in
        if let error = error {
          result(FlutterError(code: "ICON_ERROR", message: error.localizedDescription, details: nil))
        } else {
          result(nil)
        }
      }
    }
  }
}
