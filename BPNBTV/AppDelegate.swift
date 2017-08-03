//
//  AppDelegate.swift
//  BPNBTV
//
//  Created by Raditya Maulana on 3/18/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications
import GooglePlaces
import GoogleMaps
import SwiftyJSON
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,
UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.removeObject(forKey: "MENU")
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {gra, _ in
            
            })
            // For iOS 10 data message (sent via FCM
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        
        application.registerForRemoteNotifications()
        
        
        //setup google maps
        GMSPlacesClient.provideAPIKey(Constants.GMAP_API_KEY)
        GMSServices.provideAPIKey(Constants.GMAP_API_KEY)
        return true
    }

    internal var shouldRotate = false
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return shouldRotate ? .allButUpsideDown : .portrait
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
    
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        Messaging.messaging().subscribe(toTopic: "alert")
        Messaging.messaging().subscribe(toTopic: "headline")
    }
    
    /*func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        /*guard
            let dataType = userInfo["type"] as? String,
            let pushId = userInfo["id"] as? String else {return}*/
        /*let alert = UIAlertController(title: "ERROR", message:"ASU", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
        if let topVC = UIApplication.topViewController(){
            topVC.present(alert, animated: true, completion: nil)
        }*/
        //redirectToHomeForNotification(pushType:dataType, pushId: pushId)
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }
        
        //analyse(notification: userInfo)
        //completionHandler(UIBackgroundFetchResult.newData)
        
    }*/
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        printLog(content: "DEVICE TOKEN : \(token)")
        Messaging.messaging().subscribe(toTopic: "alert")
        Messaging.messaging().subscribe(toTopic: "headline")
        /*if let apns = Messaging.messaging().apnsToken{
            let token2 = apns.map { String(format: "%02.2hhx", $0) }.joined()
            printLog(content: "APNS TOKEN : \(InstanceID.instanceID().token())")
        }*/
        
        //Messaging.messaging().apnsToken = deviceToken
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        printLog(content: "MESSGE REMOTE : \(userInfo)")
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //from background
        
        printLog(content: "RESPONSE : \(response.notification)")
        completionHandler()
        let data = response.notification.request.content.userInfo
        
        guard
            //let aps = data[AnyHashable("aps")] as? NSDictionary,
            //let alert = aps["alert"] as? NSDictionary,
            //let body = alert["body"] as? String,
            //let title = alert["title"] as? String,
            let dataType = data["type"] as? String,
            let pushId = data["id"] as? String else {return}
        DispatchQueue.main.async {[weak self] in
            self?.redirectToHomeForNotification(pushType:dataType, pushId: pushId)
        }
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        guard
            let dataType = userInfo["type"] as? String,
            let pushId = userInfo["id"] as? String else {return}
        DispatchQueue.main.async {[weak self] in
            self?.redirectToHomeForNotification(pushType:dataType, pushId: pushId)
        }
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        //print(remoteMessage.appData)
        printLog(content: "REMOTE MESSAGE : \(remoteMessage.appData)")
    }

    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        printLog(content: "FCM TOKEN : \(fcmToken)")
    }
    
    func redirectToHomeForNotification(pushType:String,pushId:String){
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController{
            for rvc in rootVC.childViewControllers{
                if !rvc.isKind(of: ContainerViewController.self){
                    if rvc.isKind(of: NewMenuVC.self){
                        rvc.dismiss(animated: true, completion: nil)
                    }else if rvc.isKind(of: DetailContentViewController.self){
                        rvc.navigationController?.popToRootViewController(animated: false)
                    }else{
                        if rvc.navigationController != nil{
                            rvc.navigationController?.popToRootViewController(animated: true)
                        }else{
                            rvc.willMove(toParentViewController: nil)
                            rvc.view.removeFromSuperview()
                            rvc.removeFromParentViewController()
                        }
                        
                    }
                }else{
                    //let rvcRoot = rvc
                    for cvc in rvc.childViewControllers{
                        cvc.willMove(toParentViewController: nil)
                        cvc.view.removeFromSuperview()
                        cvc.removeFromParentViewController()
                    }
                    let homeSB = UIStoryboard(name: "Content", bundle: nil)
                    let homeVC = homeSB.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    homeVC.isFromNotification = true
                    homeVC.pushId = pushId
                    homeVC.pushType = pushType
                    rvc.addChildViewController(homeVC)
                    rvc.view.frame = CGRect(x:0, y:0, width:rvc.view.frame.size.width, height:rvc.view.frame.size.height);
                    rvc.view.addSubview(homeVC.view)
                    homeVC.didMove(toParentViewController: rvc)
                }
            }
        }
        /*let alert = UIAlertController(title: "ERROR", message:"\(UIApplication.shared.keyWindow?.rootViewController?.childViewControllers)", preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
         if let topVC = UIApplication.topViewController(){
         topVC.present(alert, animated: true, completion: nil)
         }*/
        
    }
    
    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "BPNBTV")
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
        if #available(iOS 10.0, *) {
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
        } else {
            // Fallback on earlier versions
        }
        
    }

}

