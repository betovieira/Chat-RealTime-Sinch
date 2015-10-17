//
//  AppDelegate.swift
//  ramonPediu
//
//  Created by Humberto Vieira de Castro on 10/14/15.
//  Copyright © 2015 Humberto Vieira de Castro. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SINClientDelegate {

    var window: UIWindow?
    var client: SINClient?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("dxBvflNWbE6Yc5VdlsyJehBlVu94DsUZuHGfVBlg",
            clientKey: "lWLAjimNNLIEwkN8u5r86MvDCX5Aasma2jDHIRmC")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        return true
    }
    
    func initChat(userID: String) {
        // Override point for customization after application launch.
        if (client == nil) {
            client = Sinch.clientWithApplicationKey("9817a69c-8417-4f05-85b4-645eb8b7e2b6", applicationSecret: "KGfkPu4ckk+rdgcRGdXVCQ==", environmentHost: "sandbox.sinch.com", userId: userID)
            
            client?.setSupportMessaging(true)
            client?.setSupportCalling(false)
            client?.delegate = self
            //        client?.enableManagedPushNotifications()
            
            client?.setSupportActiveConnectionInBackground(true)
            client?.start()
            client?.startListeningOnActiveConnection()
            print("Entra aqui")
        }
        
        

    }
    
    func client(client: SINClient!, logMessage message: String!, area: String!, severity: SINLogSeverity, timestamp: NSDate!) {
        print("ow")
    }
    
    func client(client: SINClient!, requiresRegistrationCredentials registrationCallback: SINClientRegistration!) {
        print("ow1")

    }
    
    func clientDidFail(client: SINClient!, error: NSError!) {
        print("ow3")

    }
    
    func clientDidStart(client: SINClient!) {
        print("Ta funfando o client")
        
    }
    func clientDidStop(client: SINClient!) {
        print("ow4")

    }
    
    
    
    
    
    
    
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

