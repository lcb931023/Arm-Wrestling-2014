//
//  OnboardingScene.swift
//  Arm Wrestling 2014
//
//  Created by Changbai Li on 14/11/14.
//  Copyright (c) 2014年 Teriyaki Studio. All rights reserved.
//

import SpriteKit

class OnboardingScene: SKScene {

    //let handshake = SKSpriteNode(imageNamed: "handshake_T")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
      //  handshake.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            
        }
    }

    override func update(currentTime: CFTimeInterval) {
        if (!paused)
        {
        //    handshake.position.x += 1;
        }
    }
}