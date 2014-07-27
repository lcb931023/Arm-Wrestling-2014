//
//  GameScene.swift
//  Arm Wrestling 2014
//
//  Created by Changbai Li on 14-7-12.
//  Copyright (c) 2014年 Teriyaki Studio. All rights reserved.
//

import SpriteKit

let handshake = SKSpriteNode(imageNamed: "handshake_T")
var comboFlag = 0;
var plusAmount:Float = 15;
var minusAmount:Float = 15;

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"HelveticaNeue")
        myLabel.text = "Tap your side of screen to wrestle!";
        myLabel.fontSize = 25;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(myLabel)
        
        handshake.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(handshake)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if (location.y < CGRectGetMidY(self.frame))
            {
                if (comboFlag < 0) {
                    plusAmount = 15;
                }
                comboFlag = 1;
                handshake.position.y += plusAmount;
                plusAmount += 3;
            } else {
                if (comboFlag > 0) {
                    minusAmount = 15;
                }
                comboFlag = -1;
                handshake.position.y -= minusAmount;
                minusAmount += 3;
            }
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
