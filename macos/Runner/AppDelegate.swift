import Cocoa
import FlutterMacOS
import FirebaseCore
import FirebaseAuth

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
          [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        return true
    }
    
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}
