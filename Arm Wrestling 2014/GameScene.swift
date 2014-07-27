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

var timeInitial:CFTimeInterval = 0;

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        // Implement timer here?
        
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
            //
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
            
            
            if(handshake.position.y <= 0){
                let endMessage = SKLabelNode(fontNamed:"HelveticaNeue")
                endMessage.text = "Player 1 Wins!";
                endMessage.fontSize = 25;
                endMessage.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
                self.addChild(endMessage)
            }
            else if(handshake.position.y >= CGRectGetHeight(self.frame)){
                let endMessage = SKLabelNode(fontNamed:"HelveticaNeue")
                endMessage.text = "Player 2 Wins!";
                endMessage.fontSize = 25;
                endMessage.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
                self.addChild(endMessage)
            }
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if (timeInitial==0)
        {
            timeInitial = currentTime;
        }
        println(currentTime);
    }
}
