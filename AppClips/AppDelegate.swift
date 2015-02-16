//
//  AppDelegate.swift
//  AppClips
//
//  Created by Daniel Sanche on 2015-02-15.
//  Copyright (c) 2015 Daniel Sanche. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        if let scheme = url.scheme {
            println("launching with: \(scheme)")
        }
        
        if url.scheme == "appclipreturn" {
            
            if let rootView = ((self.window?.rootViewController as? UINavigationController)?.topViewController as? ViewController){
                
                rootView.completedInstall()
                
                return true
            }
        } else if url.scheme == "appcliplaunch" {
            
            if let rootView = ((self.window?.rootViewController as? UINavigationController)?.topViewController as? ViewController){
                rootView.performSegueWithIdentifier("push", sender: nil)
                return true
            }
        }
        
        
        
        return false
    }


}

