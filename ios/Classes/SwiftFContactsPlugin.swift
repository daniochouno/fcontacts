import Flutter
import UIKit

public class SwiftFContactsPlugin: NSObject, FlutterPlugin {

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "fcontacts", binaryMessenger: registrar.messenger())
    let instance = SwiftFContactsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "getPlatformVersion") {
        result( "iOS " + UIDevice.current.systemVersion )
    } else if (call.method == "list") {
        list { items in
            result( items )
        }
    }
  }

  private func list( onSuccess: @escaping ([[String:Any]]?) -> () ) {
      if #available(iOS 9.0, *) {
          SwiftFContactsHandler.instance.list { items in
              onSuccess( items )
          }
      } else {
          onSuccess( nil )
      }
  }

}
