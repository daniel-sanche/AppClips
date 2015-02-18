//
//  AppClipGenerator.swift
//  
//
//  Created by Daniel Sanche on 2015-02-15.
//
//

import UIKit
import Foundation

class AppClips: NSObject {
    
    
    let server = RoutingHTTPServer()
    var returnURL : String
    var launchURL : String
    var icon :UIImage?
    var iconTextData : String? {
        get {
            if icon != nil {
                let iconData =  UIImagePNGRepresentation(icon!).base64EncodedDataWithOptions(nil)
                return NSString(data: iconData, encoding: NSUTF8StringEncoding)
            }
            return nil
        }
    }

    var identifier : String
    var name : String
    
    var bgTask : UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    init(clipURL:String, name:String, returnURL:String, identifier:String) {
        self.returnURL = returnURL
        self.launchURL = clipURL
        self.identifier = identifier
        self.name = name
    }
    
    init(clipURL:String, name:String, returnURL:String, identifier:String, icon:UIImage?) {
        self.returnURL = returnURL
        self.launchURL = clipURL
        self.icon = icon
        self.identifier = identifier
        self.name = name
    }
    
    
    func stopServer(){
        
        self.server.stop()
        
        if self.bgTask != UIBackgroundTaskInvalid {
            UIApplication.sharedApplication().endBackgroundTask(self.bgTask)
            self.bgTask = UIBackgroundTaskInvalid
        }
    }
    
    func startServer() {
      
        let iconString = self.iconTextData
        
        server.setPort(8000)
        
        var firstTime = true;
        server.handleMethod("GET", withPath: "/start") { (Request, response) -> Void in
            
            let responseString = "<HTML><HEAD><title>Profile Install</title></HEAD><script> function load() { window.location.href='http://localhost:8000/load/'; } var int=self.setInterval(function(){load()},400);                </script><BODY></BODY></HTML>"
            
            response.respondWithString(responseString)
        }
        
        server.handleMethod("GET", withPath: "/load") { (Request, response) -> Void in
            if firstTime  {
                firstTime = false;
                
                response.setHeader("Content-Type", value: "application/x-apple-aspen-config")
                response.respondWithData(self.mobileConfig(iconString))
            } else {
                response.statusCode = 302
                response.setHeader("Location", value: self.returnURL)
            }
        }
        
        server.start(nil)
        self.bgTask  = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({ () -> Void in
            self.stopServer()
        })
        UIApplication.sharedApplication().openURL(NSURL(string: "http://localhost:8000/start/")!)
    }


    func mobileConfig(iconString:NSString?) -> NSData {
        var iconText = ""
        if let encodedIcon = iconString  {
            iconText = "<key>Icon</key><data>\(encodedIcon)</data>"
        }
        
        let uuid = NSUUID().UUIDString
        let uuid2 = NSUUID().UUIDString
        
        var baseString = "<?xml version='1.0' encoding='UTF-8'?><!DOCTYPE plist PUBLIC '-//Apple//DTD PLIST 1.0//EN' 'http://www.apple.com/DTDs/PropertyList-1.0.dtd'><plist version='1.0'><dict><key>PayloadContent</key><array><dict><key>FullScreen</key><true/><key>IsRemovable</key><true/>\(iconText)<key>Label</key><string>\(name)</string><key>PayloadDescription</key><string>Configures settings for a Web Clip</string><key>PayloadDisplayName</key><string>Web Clip</string><key>PayloadIdentifier</key><string>\(identifier).apple.webClip.managed./(udid)</string><key>PayloadType</key><string>com.apple.webClip.managed</string><key>PayloadUUID</key><string>\(uuid)</string><key>PayloadVersion</key><real>1</real><key>Precomposed</key><true/><key>URL</key><string>\(launchURL)</string><key>Precomposed</key><true/></dict></array><key>PayloadDisplayName</key><string>\(name)</string><key>PayloadIdentifier</key><string>\(identifier)</string><key>PayloadRemovalDisallowed</key><false/><key>PayloadType</key><string>Configuration</string><key>PayloadUUID</key><string>\(uuid2)</string><key>PayloadVersion</key><integer>1</integer></dict></plist>"
        
        return baseString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    }

}
