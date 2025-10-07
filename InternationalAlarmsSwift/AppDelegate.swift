//
//  AppDelegate.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//


import UIKit
import UserNotifications
import AVFoundation

@objc class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, AVAudioPlayerDelegate {
    
    var window: UIWindow?
    var audioPlayer: AVAudioPlayer?
    var stopSound = false
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        print("In AppDelegate didFinishLaunchingWithOptions")
        
        // Window setup (needed if you still use UIKit view controllers)
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Database initialization
        let dbHelper = DatabaseHelper.shared
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        print("Calling dbHelper.checkAndCreateDatabase(")
        let created = dbHelper.checkAndCreateDatabase()
        if !created {
            DatabaseUpdateUtils.updateDatabaseAndPreserveAlarms()
        }
        
        DatabaseUpdateUtils.updateLocationNames()
        DatabaseUpdateUtils.updateAddSoundFieldToAlarms()
        DatabaseUpdateUtils.updateAddRepeatFieldToAlarms()
        
        // Root ViewController setup (UIKit)
        let masterVC = MasterViewController(nibName: "MasterViewController", bundle: nil)
        let navController = UINavigationController(rootViewController: masterVC)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        // Local notifications permission
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Local notifications permission granted")
            } else {
                print("Local notifications permission denied")
            }
        }
        
        // Audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("Audio session error: \(error.localizedDescription)")
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        return true
    }
    
    // MARK: UNUserNotificationCenterDelegate
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.alert, .sound])
    }
    
    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}
}
