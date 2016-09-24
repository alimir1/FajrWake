//
//  AppDelegate.swift
//  Fajr Wake
//
//  Created by Ali Mir on 5/20/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var activity: NSObjectProtocol?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Default Settings for PrayerTimes
        let settings = UserDefaults.standard
        if UserDefaults.standard.bool(forKey: "launchedBefore") == false {
            // set default settings for prayertimes
            settings.set(7, forKey: PrayerTimeSettingsReference.CalculationMethod.rawValue)
            settings.set(0, forKey: PrayerTimeSettingsReference.AsrJuristic.rawValue)
            settings.set(0, forKey: PrayerTimeSettingsReference.AdjustHighLats.rawValue)
            settings.set(1, forKey: PrayerTimeSettingsReference.TimeFormat.rawValue)
            settings.set(AlarmSounds.KazemZadeh.rawValue, forKey: "DefaultSound")
            settings.set(AlarmSoundsSectionTitles.Adhan.rawValue, forKey: "DefaultSoundTitle")
        }
        
        // PREVENT APP NAP!!
        activity = ProcessInfo().beginActivity(options: ProcessInfo.ActivityOptions.userInitiated, reason: "NSTimers should not be prevented by app nap")
        
        // navigation bar appearence
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.barTintColor = UIColor(red: 0.9294, green: 0.298, blue: 0.2588, alpha: 1.0) /* #ed4c42 */
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // Status bar white
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        
        return true
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
    }
}














