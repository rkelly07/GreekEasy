//
//  AppDelegate.swift
//  Events
//
//  Created by Andrew Titus on 3/27/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        Parse.enableLocalDatastore()
        Parse.setApplicationId("wPoPnVj9UwFop3wfcx01uiMpX9UrVeWb07ks4vSk", clientKey: "JuWPCoeqymU9wf1vo0PJWrzapPF2klTxbPQhFTWR")
        
        /*
        var sampleEvent1 = PFObject(className: "Event")
        var sampleEvent2 = PFObject(className: "Event")
        var sampleEvent3 = PFObject(className: "Event")
        
        // Create first sample event
        sampleEvent1["name"] = "Make Ryan Kelly fix my code"
        sampleEvent1["date"] = NSDate(timeIntervalSinceNow: 0)
        sampleEvent1["location"] = "MIT"
        sampleEvent1["description"] = "Do it"
        sampleEvent1["category"] = "work"
        sampleEvent1["createdBy"] = "drew"
        sampleEvent1.save()
        println("done")
        
        // Create second sample event
        sampleEvent2["name"] = "Make Ryan Kelly do my taxes"
        sampleEvent2["date"] = NSDate(timeIntervalSinceNow: 360.0)
        sampleEvent2["location"] = "MIT"
        sampleEvent2["description"] = "Munny"
        sampleEvent2["category"] = "work"
        sampleEvent2["createdBy"] = "drew"
        sampleEvent2.save()
        println("done")
        
        // Create third sample event
        sampleEvent3["name"] = "Make Ryan Kelly clean"
        sampleEvent3["date"] = NSDate(timeIntervalSinceNow: -1260.0)
        sampleEvent3["location"] = "MIT"
        sampleEvent3["description"] = "Lemon pledge"
        sampleEvent3["category"] = "work"
        sampleEvent3["createdBy"] = "drew"
        sampleEvent3.save()
        println("done")
        */

        return true
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

