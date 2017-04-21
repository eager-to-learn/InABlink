//
//  AppDelegate.swift
//  InABlink
//
//  Created by Corey Salzer on 4/3/17.
//  Copyright © 2017 Washington University in St. Louis. All rights reserved.
//  Notification Code from https://github.com/anishparajuli555/ios10LocalNotification
//

import UIKit
import UserNotifications
import UserNotificationsUI
import CoreData
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.cyan], for: .selected)
        UINavigationBar.appearance().tintColor = UIColor.white
        // Override point for customization after application launch.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization
        }
        center.removeAllPendingNotificationRequests()
        
        checkForFirstTimeUsage()
        
        setUpSurveys()
        setUpSurveyNotifications()
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
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "InABlink")
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
    }
    
    func note(fromRegionIdentifier identifier: String) -> String? {
        let savedItems = UserDefaults.standard.array(forKey: PreferencesKeys.savedItems) as? [NSData]
        let geotifications = savedItems?.map { NSKeyedUnarchiver.unarchiveObject(with: $0 as Data) as? Geotification }
        let index = geotifications?.index { $0?.identifier == identifier }
        return index != nil ? geotifications?[index!]?.note : nil
    }
    
    func handleEvent(forRegion region: CLRegion!, eventType: EventType) {
        let content = UNMutableNotificationContent()
        
        content.title = eventType.message
        content.subtitle = "Make a No Judgement Call"
        if let message = UserDefaults.standard.value(forKeyPath: "message") {
            content.body = String(describing: message)
        }
        else {
            if eventType == .dangerous {
                content.body = "I have many people I can reach out when I need them"
            }
            else {
                content.body = "I'm entering a place that supports my efforts"
            }
        }

        content.sound = UNNotificationSound.default()
        
        // Deliver the notification
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1.0, repeats: false)
        let request = UNNotificationRequest(identifier:eventType.rawValue, content: content, trigger: trigger)

        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            
            if (error != nil){
                print(error?.localizedDescription ?? "Notification Failed")
            }
        }
    }
    
    private func setUpSurveyNotifications() {
        let surveyNames = UserDefaults.standard.array(forKey: "surveyNames") as! [String]
        
        for surveyName in surveyNames {
            let content = UNMutableNotificationContent()
            content.title = "Take Survey"
            content.subtitle = " "
            content.body = " "
            content.sound = UNNotificationSound.default()
            
            // Deliver the notification
            var date = DateComponents()
            
            if let time = UserDefaults.standard.value(forKey: "surveyTime") {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                let calendar = Calendar.current
                date.hour = calendar.component(.hour, from: time as! Date)
                date.minute = calendar.component(.minute, from: time as! Date)
                date.second = 00
            }
            else {  // if user defaults not set yet, pick arbitrary survey time
                date.hour = 9
                date.minute = 0
                date.second = 00
            }
            let trigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: true)
            let request = UNNotificationRequest(identifier:surveyName, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().add(request){(error) in
                
                if (error != nil){
                    print(error?.localizedDescription ?? "Notification Failed")
                }
            }
        }
    }
    
    private func setUpSurveys() {
        let surveyNames = ["Survey 1"]
        UserDefaults.standard.set(surveyNames, forKey: "surveyNames")
        
        for surveyName in surveyNames {
            let survey = Survey(questions:
                [
                    Question(content: "I am experiencing bouts of depression today."),
                    Question(content: "I am feeling the need to drink/use drugs."),
                    Question(content: "I am feeling angry at the world in general."),
                    Question(content: "I am doing things to stay sober today."),
                    Question(content: "I have thought about drinking/using drugs today."),
                    Question(content: "I'm feeling sorry for myself today."),
                    Question(content: "I am thinking clear today."),
                    Question(content: "I have a positive outlook on life today.")
                ], name: surveyName
            )
            
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: survey), forKey: survey.name)
        }
    }
    
    private func checkForFirstTimeUsage() {
        if UserDefaults.standard.object(forKey: "isNotFirstTime") as? Bool == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LandingViewController") as! LandingViewController

            self.window?.rootViewController? = controller
        }
    }

}


extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            guard let savedItems = UserDefaults.standard.array(forKey: PreferencesKeys.savedItems) else { return }
            for savedItem in savedItems {
                guard let geotification = NSKeyedUnarchiver.unarchiveObject(with: savedItem as! Data) as? Geotification else { continue }
                if region.identifier == geotification.identifier {
                    handleEvent(forRegion: region, eventType: geotification.eventType)
                }
            }
        }
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        if String(response.notification.request.identifier) == EventType.dangerous.rawValue || String(response.notification.request.identifier) == EventType.safe.rawValue {
            (self.window?.rootViewController as! UITabBarController).selectedIndex = 3
            ((self.window?.rootViewController as! UITabBarController).selectedViewController as! MessagesViewController).messageTitle.text = EventType(rawValue: String(response.notification.request.identifier))?.message
        }
        else {
            let data = UserDefaults.standard.data(forKey: response.notification.request.identifier)!
            let survey = NSKeyedUnarchiver.unarchiveObject(with: data) as? Survey
            (self.window?.rootViewController as! UITabBarController).selectedIndex = 2
            let surveyNavigationController = (self.window?.rootViewController as! UITabBarController).selectedViewController as! UINavigationController
            surveyNavigationController.viewControllers[0].performSegue(withIdentifier: "goToSurveyView", sender: survey)
        }
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10

        completionHandler( [.alert,.sound,.badge])
    }
    
}




