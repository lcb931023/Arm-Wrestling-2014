//
//  GameScene.swift
//  Arm Wrestling 2014
//
//  Created by Changbai Li on 14-7-12.
//  Copyright (c) 2014年 Teriyaki Studio. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let handshake = SKSpriteNode(imageNamed: "handshake_T")
    var comboFlag = 0;
    var plusAmount:Float = 15;
    var minusAmount:Float = 15;
    let myLabel = SKLabelNode(fontNamed:"HelveticaNeue");
    
    var timeInitial:CFTimeInterval = 0;
    var timeSinceInit:CFTimeInterval = 0;
    let exitDuration:CFTimeInterval = 2;
    var exitTimer:CFTimeInterval = 0;
    var gameStarted:Bool = false;
    var gameEnded:Bool = false;
    var exitStarted:Bool = false;
    var pOneDidWin:Bool = false;
    
    typealias gameOverBlock = (didWin : Bool) -> Void
    var gameOverDelegate: gameOverBlock?

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        handshake.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(handshake)
        
        myLabel.text = "Tap your side of screen to wrestle!";
        myLabel.fontSize = 25;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        myLabel.zPosition = 100;
        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
    
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            // Game input
            if (gameStarted && !gameEnded)
            {
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
                
                // Win Detection
                if(handshake.position.y <= 0){
                    myLabel.text = "Player 1 Wins!";
                    pOneDidWin = true;
                    gameEnded = true;
                }
                else if(handshake.position.y >= CGRectGetHeight(self.frame)){
                    myLabel.text = "Player 2 Wins!";
                    pOneDidWin = false;
                    gameEnded = true;
                }
                else{
                    myLabel.text = "";
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        if (!paused)
        {
            /* Called before each frame is rendered */
            if (timeInitial==0)
            {
                timeInitial = currentTime;
            }
            timeSinceInit = currentTime - timeInitial;
            
            if (!gameStarted)
            {
                // instruction & countdown
                preGameCountdown();
            }
            if (gameEnded)
            {
                // End game delay to Summary View
                if (!exitStarted)
                {
                    exitStarted = true;
                    exitTimer = currentTime;
                }
                delayedExit(currentTime);
            }
        }
    }
    
    func preGameCountdown() {
        if (timeSinceInit>2){
            if (timeSinceInit<3){
                myLabel.text = "3";
            }else if (timeSinceInit<4){
                myLabel.text = "2";
            }else if (timeSinceInit<5){
                myLabel.text = "1";
            }else if (timeSinceInit<6){
                myLabel.text = "START!";
                gameStarted = true;
            }
            myLabel.fontSize = 65;
        }
    }
    
    func delayedExit(currentTime: CFTimeInterval) {
        if ( (currentTime - exitTimer) > exitDuration)
        {
            if let gameOverCallback = gameOverDelegate {
                paused = true;
                gameOverCallback(didWin: pOneDidWin)
            }
            println("[GameScene] Game over")
        }
    }
}
