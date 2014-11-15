//
//  OnboardingScene.swift
//  Arm Wrestling 2014
//
//  Created by Changbai Li on 14/11/14.
//  Copyright (c) 2014年 Teriyaki Studio. All rights reserved.
//

import SpriteKit

class OnboardingScene: SKScene {

    let handshake = SKSpriteNode(imageNamed: "handshake_T")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        handshake.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(handshake);
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            
        }
    }
    
    func createRect( hex:Int ) -> SKSpriteNode{
        //gets color data from colorize
        let color = colorize(hex, alpha:1.0)
        
        var rect = SKSpriteNode(color: color, size: CGSizeMake( CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)/2) );
        return rect;
    }
    
    func colorize (hex: Int, alpha: Double = 1.0) -> UIColor {
        //gets hex and converts to rgb values 0.0 - 1.0
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        var color: UIColor = UIColor( red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha:CGFloat(alpha) )
        return color
    }

    override func update(currentTime: CFTimeInterval) {
        if (!paused)
        {
            handshake.position.x += 1;
        }
    }
}