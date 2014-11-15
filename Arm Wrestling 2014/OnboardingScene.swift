//
//  OnboardingScene.swift
//  Arm Wrestling 2014
//
//  Created by Changbai Li on 14/11/14.
//  Copyright (c) 2014年 Teriyaki Studio. All rights reserved.
//

import SpriteKit

class OnboardingScene: SKScene {

    // Elements
    var player1 :Player?
    var player2 :Player?
    var plusAmount:Float = 15;
    var minusAmount:Float = 15;
    var inc: Float = 35;
    // Exit Setup
    typealias sequenceOverBlock = () -> Void
    var sequenceOverDelegate: sequenceOverBlock?
    // Flags, States, Timers
    var gameEnded:Bool = false;
    var exitStarted:Bool = false;
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        //bottom
        player1 = Player(hex: 0x2D99EC, width: CGRectGetWidth(self.frame), height: CGRectGetHeight(self.frame)/2);
        player1!.position = CGPointMake(CGRectGetMidX(self.frame), (CGRectGetHeight(player1!.frame)/2));
        self.addChild(player1!)
        
        //top
        player2 = Player(hex: 0xFF5D73, width: CGRectGetWidth(self.frame), height: CGRectGetHeight(self.frame)/2);
        player2!.position = CGPointMake(CGRectGetMidX(self.frame), (CGRectGetHeight(player1!.frame)*1.5));
        self.addChild(player2!)
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            
            if (location.y < CGRectGetMidY(self.frame))
            {
                player2!.size.height -= CGFloat(inc);
                player1!.size.height += CGFloat(inc);
                player2!.position.y += CGFloat(inc/2);
                player1!.position.y += CGFloat(inc/2);
                
                //increase player 2's tap count
                player1?.taps += 1;
            } else {
                player2!.size.height += CGFloat(inc);
                player1!.size.height -= CGFloat(inc);
                player2!.position.y -= CGFloat(inc/2);
                player1!.position.y -= CGFloat(inc/2);
                
                //increase player 1's tap count
                player2?.taps += 1;
            }
            
            // Finish detection
            if(player1!.size.height >= self.frame.height ||
                (player2!.size.height >= self.frame.height)){
                    gameEnded = true;
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if (!paused)
        {
            if (gameEnded && !exitStarted) {
                if let sequenceOverCallback = sequenceOverDelegate {
                    paused = true;
                    sequenceOverCallback();
                    exitStarted = true;
                }
            }
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
    
}