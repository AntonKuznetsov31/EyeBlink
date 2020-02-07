import UIKit

@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navController = UINavigationController(rootViewController: CompositionRoot.sharedInstance.resolveLookingForViewController())
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()

        return true
    }
}
