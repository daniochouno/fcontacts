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
        if let arguments = call.arguments as? [String:String] {
            list( query: arguments["query"] ) { items in
                result( items )
            }
        } else {
            list { items in
                result( items )
            }
        }
    }
  }

    private func list( query: String? = nil, onSuccess: @escaping ([[String:Any]]?) -> () ) {
      if #available(iOS 9.0, *) {
        SwiftFContactsHandler.instance.list( query: query ) { items in
          onSuccess( items )
        }
      } else {
        onSuccess( nil )
      }
  }

}
