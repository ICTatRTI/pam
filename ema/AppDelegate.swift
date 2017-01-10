//
//  AppDelegate.swift
//  workaday
//
//  Created by Adam Preston on 4/6/16.
//  Copyright © 2016 RTI. All rights reserved.
//

import UIKit
import CoreData
import ResearchNet

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // register notification (this will allow the user to grant notifications for this app
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        
        // Configure daily notifications
        let notiftypes:UIUserNotificationType = [.alert, .badge, .sound]
        
        let notifSettings:UIUserNotificationSettings = UIUserNotificationSettings(types: notiftypes, categories: nil)
        
        UIApplication.shared.registerUserNotificationSettings(notifSettings)
        
        //Avoid duplicate notificaions
        application.cancelAllLocalNotifications();
        
        // Configure notifications for each day (sunday is 1)
        scheduleLocalNotification(9,minute: 0, weekDay: 1)
        scheduleLocalNotification(12,minute: 0, weekDay: 1)
        scheduleLocalNotification(17,minute: 0, weekDay: 1)

        scheduleLocalNotification(9,minute: 0, weekDay: 2)
        scheduleLocalNotification(12,minute: 0, weekDay: 2)
        scheduleLocalNotification(17,minute: 0, weekDay: 2)

        scheduleLocalNotification(9,minute: 0, weekDay: 3)
        scheduleLocalNotification(12,minute: 0, weekDay: 3)
        scheduleLocalNotification(17,minute: 0, weekDay: 3)
        
        scheduleLocalNotification(9,minute: 0, weekDay: 4)
        scheduleLocalNotification(12,minute: 0, weekDay: 4)
        scheduleLocalNotification(17,minute: 0, weekDay: 4)
        
        scheduleLocalNotification(9,minute: 0, weekDay: 5)
        scheduleLocalNotification(12,minute: 0, weekDay: 5)
        scheduleLocalNotification(17,minute: 0, weekDay: 5)
        
        scheduleLocalNotification(9,minute: 0, weekDay: 6)
        scheduleLocalNotification(12,minute: 0, weekDay: 6)
        scheduleLocalNotification(17,minute: 0, weekDay: 6)
        
        scheduleLocalNotification(9,minute: 0, weekDay: 7)
        scheduleLocalNotification(12,minute: 0, weekDay: 7)
        scheduleLocalNotification(17,minute: 0, weekDay: 7)
        
        // Default the dates that the surveys were completed. Default to sometime in the past, why not 1970
        
        let newYears1970 = Date(timeIntervalSince1970: 0)
        
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "weekday_timestamp") == nil {
            defaults.set(newYears1970, forKey: "weekday_timestamp")
        }
        
        if defaults.object(forKey: "weekend_timestamp") == nil {
            defaults.set(newYears1970, forKey: "weekend_timestamp")
        }
        
        return true
    }
    
    
    func scheduleLocalNotification(_ hour:Int, minute:Int, weekDay:Int){
        
        var calendar =  Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone.current
        
        var components = DateComponents()
        components.weekday = weekDay
        
        let date = Date()
        let notificationDate = (calendar as NSCalendar).date(byAdding: components, to: date, options: [])
        let adjustedDate: Date = (calendar as NSCalendar).date(bySettingHour: hour, minute: minute, second: 0, of: notificationDate!, options: NSCalendar.Options())!
        
        let localNotificaion = UILocalNotification()
        localNotificaion.fireDate = adjustedDate
        localNotificaion.alertBody = "Please complete your WorkDay study activities today.  Thanks again for participating."
        localNotificaion.timeZone = TimeZone.current
        
        localNotificaion.repeatInterval = .weekOfYear
        UIApplication.shared.scheduleLocalNotification(localNotificaion)
        
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "org.rti.workaday" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "workaday", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
}

