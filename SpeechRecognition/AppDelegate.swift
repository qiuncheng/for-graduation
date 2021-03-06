//
//  AppDelegate.swift
//  SpeedRecognition
//
//  Created by yolo on 2017/3/13.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    window = UIWindow()
    window?.frame = UIScreen.main.bounds
    let navVC = MainNavigationController()
    window?.rootViewController = navVC
    
    window?.makeKeyAndVisible()
    
    IFlySetting.setLogFile(.LVL_ALL)
    let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
    if let cachePath = paths.first {
      IFlySetting.setLogFilePath(cachePath)
    }
    let initString = "appid=\(Config.appID)"
    IFlySpeechUtility.createUtility(initString)
    
    IFlySetting.showLogcat(true)
    return true
  }
  
  func cache() {
    CacheHelper.share.updateMathFormula(withValues: ["加", "加上"], forKey: "+")
    CacheHelper.share.updateMathFormula(withValues: ["减", "减去"], forKey: "-")
  }
  
  
  func applicationWillResignActive(_ application: UIApplication) {
    
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
  }
  
  
}

