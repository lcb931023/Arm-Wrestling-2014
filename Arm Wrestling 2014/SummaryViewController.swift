//
//  SummaryViewController.swift
//  Arm Wrestling 2014
//
//  Created by Changbai Li on 14-8-9.
//  Copyright (c) 2014年 Teriyaki Studio. All rights reserved.
//

import UIKit
import SpriteKit

class SummaryViewController: UIViewController {
    
    var p1DidWin: Bool = false;
    var p1TapCount: Int = 0;
    var p2TapCount: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayContent();
        
    }
    
    func displayContent (){
        var width = self.view.frame.size.width;
        var centerX = self.view.frame.size.width/2;
        
        /* Create winner label */
        var winnerLabel = UILabel(frame: CGRectMake(0, 130, width, 21))
        winnerLabel.textAlignment = NSTextAlignment.Center;
        if(p1DidWin){
            winnerLabel.text = "B L U E   W I N S !";
        }
        else{
            winnerLabel.text = "P I N K  W I N S !";
        }
        
        self.view.addSubview(winnerLabel);
        
        //p1 tap count
        var p1Label = UILabel(frame:CGRectMake(centerX-65,180,120,20));
        p1Label.textAlignment = NSTextAlignment.Left;
        p1Label.textColor = colorize(0x2D99EC);
        p1Label.font = UIFont(name: "HelveticaNeue", size: CGFloat(16));
        p1Label.text = "P1 Taps: " + String(p1TapCount);
        self.view.addSubview(p1Label);
        
        //p2 tap count
        var p2Label = UILabel (frame:CGRectMake(centerX-65,210,120,20));
        p2Label.textAlignment = NSTextAlignment.Left;
        p2Label.textColor = colorize(0xFF5D73);
        //p2Label.textColor = UIColor(red:45.0,green:153.0,blue:236.0,alpha: 1.0);
        p2Label.font = UIFont(name: "HelveticaNeue", size: CGFloat(16));
        p2Label.text = "P2 Taps: " + String(p2TapCount);
        self.view.addSubview(p2Label);
    }
    
    func colorize (hex: Int, alpha: Double = 1.0) -> UIColor {
        //gets hex and converts to rgb values 0.0 - 1.0
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        var color: UIColor = UIColor( red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha:CGFloat(alpha) )
        return color
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
