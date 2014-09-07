//
//  GameScene.swift
//  Arm Wrestling 2014
//
//  Created by Changbai Li & Danny Nguyen on 14-7-12.
//  Copyright (c) 2014年 Teriyaki Studio. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // Elements
    let handshake = SKSpriteNode(imageNamed: "handshake_T")
    let myLabel = SKLabelNode(fontNamed:"HelveticaNeue");
    var player1 :SKSpriteNode?
    var player2 :SKSpriteNode?
    var comboFlag = 0;
    var plusAmount:Float = 15;
    var minusAmount:Float = 15;
    // Flow
    var timeInitial:CFTimeInterval = 0;
    var timeSinceInit:CFTimeInterval = 0;
    let exitDuration:CFTimeInterval = 2;
    var exitTimer:CFTimeInterval = 0;
    var gameStarted:Bool = false;
    var gameEnded:Bool = false;
    var exitStarted:Bool = false;
    var pOneDidWin:Bool = false;
    // Exit Setups
    typealias gameOverBlock = (didWin : Bool) -> Void
    var gameOverDelegate: gameOverBlock?

    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        handshake.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        //self.addChild(handshake)
        
        myLabel.text = "GET READY!";
        myLabel.fontSize = 25;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        myLabel.zPosition = 100;
        self.addChild(myLabel)
        
        
        //top
        player1 = createRect(0xFF5D73);
        player1!.position = CGPointMake(CGRectGetMidX(self.frame), (CGRectGetHeight(player1!.frame)*1.5));
        self.addChild(player1)
        
        //bottom
        player2 = createRect(0x2D99EC);
        player2!.position = CGPointMake(CGRectGetMidX(self.frame), (CGRectGetHeight(player1!.frame)/2));
        self.addChild(player2)

    }
    
    /*------------------------------------------------------------------------------/
      createRect: Creating Rectangles in View to portray each player
    /-----------------------------------------------------------------------------*/
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
                    //handshake.position.y += plusAmount;
                    player1!.size.height -= plusAmount;
                    player2!.size.height += plusAmount;
                    player1!.position.y += plusAmount/2;
                    player2!.position.y += plusAmount/2;
                    plusAmount += 3;
                    
                    //increase player 2's tap count
                    p2_taps += 1;
                } else {
                    if (comboFlag > 0) {
                        minusAmount = 15;
                    }
                    comboFlag = -1;
                    //handshake.position.y -= minusAmount;
                    player1!.size.height += minusAmount;
                    player2!.size.height -= minusAmount;
                    player1!.position.y -= minusAmount/2;
                    player2!.position.y -= minusAmount/2;
                    minusAmount += 3;
                    
                    //increase player 1's tap count
                    p1_taps += 1;
                }
                
                // Win Detection
                if(player2!.position.y <= 0){
                    myLabel.text = "Player 1 Wins!";
                    myLabel.fontSize = 30;
                    pOneDidWin = true;
                    gameEnded = true;
                }
                else if(player1!.position.y >= CGRectGetHeight(self.frame)){
                    myLabel.text = "Player 2 Wins!";
                    myLabel.fontSize = 30;
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
                gameOverCallback(didWin: pOneDidWin, p1TapCount: p1_taps, p2TapCount: p2_taps);
            }
            println("[GameScene] Game over")
        }
    }
}
