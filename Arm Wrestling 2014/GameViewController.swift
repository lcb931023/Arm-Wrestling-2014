//
//  GameViewController.swift
//  Arm Wrestling 2014
//
//  Created by Changbai Li on 14-7-12.
//  Copyright (c) 2014年 Teriyaki Studio. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        
        let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
        var heylook = "Fuck you Changbai";
        var uhuh = "That's what your mom said";
        var sceneData = NSData.dataWithContentsOfFile(path, options: .DataReadingMappedIfSafe, error: nil)
        var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
        archiver.finishDecoding()
        return scene
    }
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as SKView
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
            
            scene.gameOverDelegate = {[weak self] (didWin, p1TapCount, p2TapCount) in
                println("[GameViewController] Player 1 Won:\(didWin)")
                println("Player 1 Taps:", p1TapCount);
                println("Player 2 Taps:", p2TapCount);
                if let validSelf = self {
                    
                    let summaryViewController = validSelf.storyboard.instantiateViewControllerWithIdentifier("SummaryViewController") as SummaryViewController
                    
                    summaryViewController.p1DidWin = didWin;
                    summaryViewController.p1TapCount = p1TapCount;
                    summaryViewController.p2TapCount = p2TapCount;
                    
                    validSelf.presentViewController(summaryViewController, animated:true, completion:nil);

                }
            }
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
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
