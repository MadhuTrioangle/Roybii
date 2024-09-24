import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    
    
    var flutterViewController: FlutterViewController = FlutterViewController()
    lazy var flutterEngine = FlutterEngine(name: "my flutter engine")
  var sendMessageChannel: FlutterMethodChannel!
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

      flutterEngine.run();
      weak var registrar = self.registrar(forPlugin: "plugin-name")

              let factory = FLNativeViewFactory(messenger: registrar!.messenger())
              self.registrar(forPlugin: "<plugin-name>")!.register(
                  factory,
                  withId: "<platform-view-type>")
      //let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      
      flutterViewController = window.rootViewController as! FlutterViewController
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
     let batteryChannel = FlutterMethodChannel(name: "flutter.native/helper",
                                               binaryMessenger: controller.binaryMessenger)
      
      
//      sendMessageChannel.setMethodCallHandler({ [weak self]
//                 (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
////                 let data = Data((call.arguments as! String).utf8)
////                 let user = try! JSONDecoder().decode(User.self, from: data)
//     //            let name = (call.arguments as! [String: String])["name"]!
//     //            let email = (call.arguments as! [String: String])["email"]!
//                 guard call.method == "sendMessage" else {
//                     result(FlutterMethodNotImplemented)
//                     return
//                   }
//          print(call.method == "sendMessage")
////                 self?.callSomeMethod(name: user.name, email: user.email, result: result)
//             })

      batteryChannel.setMethodCallHandler({
          [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

//
//
//
//
//
//
//          let handler = ArgumentsHandler(argument: call.arguments as? [String:Any] ?? [String:Any](), channelMethod: ChannelMethods(rawValue: call.method ) ?? .sendMnemonic, result: result)
//
//          if handler.channelMethod == .enableScreenshot{
//              self?.enableScreenShot()
//              handler.handleArgument()
//
//  //
//  //                NotificationCenter.default.removeObserver(self!, name: UIApplication.userDidTakeScreenshotNotification, object: nil)
//  //            NotificationCenter.default.removeObserver(self!, name: UIApplication.userDidTakeScreenshotNotification, object: nil)
//  //            NotificationCenter.default.removeObserver(self!, name: UIApplication.userDidTakeScreenshotNotification, object: nil)
//  //            NotificationCenter.default.removeObserver(self!, name: UIApplication.userDidTakeScreenshotNotification, object: nil)
//  //            NotificationCenter.default.removeObserver(self!)
//  //            NotificationCenter.default.removeObserver(
//  //                self,
//  //                name: UIApplication.userDidTakeScreenshotNotification,
//  //                object: nil
//  //            )
//
//          }else if handler.channelMethod == .disableScreenshot{
//              self?.disableScreenShot()
//              handler.handleArgument()
//
//          }else {
//              handler.handleArgument()
//          }

           print(call.method == "sendMessage")


   })
      GeneratedPluginRegistrant.register(with: self)
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
