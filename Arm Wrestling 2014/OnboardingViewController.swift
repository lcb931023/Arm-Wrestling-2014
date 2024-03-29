//
//  OnboardingViewController.swift
//  Arm Wrestling 2014
//
//  Created by Changbai Li on 14/11/14.
//  Copyright (c) 2014年 Teriyaki Studio. All rights reserved.
//

import UIKit
import SpriteKit

//extension SKNode {
//    class func unarchiveFromFile(file : NSString) -> SKNode? {
//        
//        let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
//        var sceneData = NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe, error: nil)
//        var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData!)
//        
//        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
//        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as OnboardingScene
//        archiver.finishDecoding()
//        return scene
//    }
//}

class OnboardingViewController: UIViewController {

    var scene:OnboardingScene!;
    override func viewDidLoad() {
        super.viewDidLoad()
        scene = OnboardingScene(size: view.bounds.size)
        
        // Configure the view.
        
        let skView = view as SKView
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
        
        // Delegate
        scene.sequenceOverDelegate = {[weak self] () in
            if let validSelf = self {
                validSelf.performSegueWithIdentifier("showTitleView", sender: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showTitleView" {
            println("deiniting onboarding scene");
            //scene.delete(self);
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
