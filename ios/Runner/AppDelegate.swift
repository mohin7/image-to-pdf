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
    registerHapticsChannel(with: engineBridge.pluginRegistry)
    registerPdfKitChannel(with: engineBridge.pluginRegistry)
  }

  // MARK: - Haptics

  private func registerHapticsChannel(with registry: FlutterPluginRegistry) {
    guard let registrar = registry.registrar(forPlugin: "HapticsPlugin") else { return }
    let channel = FlutterMethodChannel(
      name: "com.imagetopdf/haptics",
      binaryMessenger: registrar.messenger()
    )
    channel.setMethodCallHandler { (call, result) in
      let generator = UINotificationFeedbackGenerator()
      generator.prepare()
      switch call.method {
      case "success":
        generator.notificationOccurred(.success)
        result(nil)
      case "error":
        generator.notificationOccurred(.error)
        result(nil)
      case "warning":
        generator.notificationOccurred(.warning)
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  // MARK: - PDFKit

  private func registerPdfKitChannel(with registry: FlutterPluginRegistry) {
    guard let registrar = registry.registrar(forPlugin: "PDFKitPlugin") else { return }
    let channel = FlutterMethodChannel(
      name: "com.imagetopdf/pdfkit",
      binaryMessenger: registrar.messenger()
    )
    let service = PDFKitService()

    channel.setMethodCallHandler { (call, result) in
      do {
        switch call.method {

        case "getPageCount":
          let args = call.arguments as! [String: Any]
          let count = try service.pageCount(path: args["path"] as! String)
          result(count)

        case "merge":
          let args = call.arguments as! [String: Any]
          let paths = args["paths"] as! [String]
          let outputPath = args["outputPath"] as! String
          let out = try service.merge(paths: paths, outputPath: outputPath)
          result(out)

        case "split":
          let args = call.arguments as! [String: Any]
          let path = args["path"] as! String
          let pages = args["pages"] as! [Int]
          let outputPath = args["outputPath"] as! String
          let out = try service.split(path: path, pageIndexes: pages, outputPath: outputPath)
          result(out)

        case "compress":
          let args = call.arguments as! [String: Any]
          let path = args["path"] as! String
          let quality = (args["quality"] as! Int)
          let outputPath = args["outputPath"] as! String
          let out = try service.compress(
            path: path,
            quality: CGFloat(quality) / 100.0,
            outputPath: outputPath
          )
          result(out)

        default:
          result(FlutterMethodNotImplemented)
        }
      } catch let err as PDFKitError {
        result(FlutterError(code: "PDF_KIT_ERROR",
                            message: err.localizedDescription,
                            details: nil))
      } catch {
        result(FlutterError(code: "UNKNOWN_ERROR",
                            message: error.localizedDescription,
                            details: nil))
      }
    }
  }
}
