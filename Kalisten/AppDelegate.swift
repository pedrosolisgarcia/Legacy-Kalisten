import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let defaultNavBar = UINavigationBarAppearance()
        defaultNavBar.configureWithOpaqueBackground()
        defaultNavBar.backgroundColor = .spaceGrey
        if let navBarFront = UIFont(name: "AvenirNextCondensed-DemiBold", size: 25) {
            defaultNavBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: navBarFront]
        }

        UINavigationBar.appearance().standardAppearance = defaultNavBar
        UINavigationBar.appearance().tintColor = .white
        
        let defaultTabBar = UITabBarAppearance()
        defaultTabBar.configureWithOpaqueBackground()
        defaultTabBar.backgroundColor = .spaceGrey
        UITabBar.appearance().standardAppearance = defaultTabBar
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().selectionIndicatorImage = UIImage(named: "selectedIcon.png")
        
        //Set the general Segmented Control appearance
        UISegmentedControl.appearance().layer.borderColor = UIColor.black.cgColor
        UISegmentedControl.appearance().layer.cornerRadius = 1
        UISegmentedControl.appearance().tintColor = .black
        
        let colorView = UIView()
        colorView.backgroundColor = UIColor.estonianBlue.opacity(percentage: 50)
        
        // use UITableViewCell.appearance() to configure
        // the default appearance of all UITableViewCells in your app
        UITableViewCell.appearance().selectedBackgroundView = colorView
        
        //To make this have effect, you need first to add a row in Info.plist with view controller... and set NO.
        var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
        
        // Initialize Parse.
        let configuration = ParseClientConfiguration {
            $0.applicationId = "pZJis8SJbostaEHXDufOIyAHkOWHXIJoDXy6FptS"
            $0.clientKey = "8xyedTLfohXIkrZOPDZw87uiom0Ny7Jvh4uOfuIz"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
        
        // Enable public read access by default, with any newly created PFObjects belonging to the current user
        let defaultACL: PFACL = PFACL()
        defaultACL.getPublicReadAccess = true
        PFACL.setDefault(defaultACL, withAccessForCurrentUser: true)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
    }

    // MARK: - Core Data stack

    /*lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Kalisten")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }*/

}

