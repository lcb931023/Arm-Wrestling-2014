//
//  GameViewController.swift
//  Arm Wrestling 2014
//
//  Created by Changbai Li on 14-7-12.
//  Copyright (c) 2014年 Teriyaki Studio. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene(size: view.bounds.size)
        
        // Configure the view.
        let skView = view as SKView
        
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
                
                let summaryViewController = validSelf.storyboard!.instantiateViewControllerWithIdentifier("SummaryViewController") as SummaryViewController
                
                summaryViewController.p1DidWin = didWin;
                summaryViewController.p1TapCount = p1TapCount;
                summaryViewController.p2TapCount = p2TapCount;
                
                validSelf.presentViewController(summaryViewController, animated:true, completion:nil);

            }
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
