//
//  ViewController.swift
//  AppClips
//
//  Created by Daniel Sanche on 2015-02-15.
//  Copyright (c) 2015 Daniel Sanche. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var generator : AppClips?;
    
    var icon = UIImage(named: "clip-icon")
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.imageView.image = icon
    }
    
    func completedInstall(){
        
        generator?.stopServer()
        generator = nil
        
        let alert = UIAlertController(title: "Welcome Back", message: "You should now see a new icon on your home screen", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func brnPressed(sender: AnyObject) {
        generator = AppClips(clipURL: "appcliplaunch://",  name:"Launcher", returnURL: "appclipreturn://", identifier:"com.example.appclip", icon:self.icon)
        generator!.startServer()
    }
    
    
    
}