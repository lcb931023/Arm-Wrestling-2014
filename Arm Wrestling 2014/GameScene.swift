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
    var inc: Float = 0;
    var defaultInc:Float = 35;
    // Flow
    var timeLimit:CFTimeInterval = 20;
    var timeInitial:CFTimeInterval = 0;
    var timeSinceInit:CFTimeInterval = 0;
    let exitDuration:CFTimeInterval = 2;
    var exitTimer:CFTimeInterval = 0;
    var gameStarted:Bool = false;
    var gameEnded:Bool = false;
    var exitStarted:Bool = false;
    var pOneDidWin:Bool = false;
    // Exit Setup
    var p1_taps:Int = 0;
    var p2_taps:Int = 0;
    
    typealias gameOverBlock = (didWin : Bool, p1TapCount: Int, p2TapCount: Int) -> Void
    var gameOverDelegate: gameOverBlock?

    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        handshake.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        myLabel.text = "GET READY!";
        myLabel.fontSize = 25;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        myLabel.zPosition = 100;
        self.addChild(myLabel)
        
        //bottom
        player1 = createRect(0x2D99EC);
        player1!.position = CGPointMake(CGRectGetMidX(self.frame), (CGRectGetHeight(player1!.frame)/2));
        self.addChild(player1!)
        
        //top
        player2 = createRect(0xFF5D73);
        player2!.position = CGPointMake(CGRectGetMidX(self.frame), (CGRectGetHeight(player1!.frame)*1.5));
        self.addChild(player2!)

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
                    player2!.size.height -= CGFloat(inc);
                    player1!.size.height += CGFloat(inc);
                    player2!.position.y += CGFloat(inc/2);
                    player1!.position.y += CGFloat(inc/2);
                    //plusAmount += inc;
                    
                    //increase player 2's tap count
                    p1_taps += 1;
                } else {
                    if (comboFlag > 0) {
                        minusAmount = 15;
                    }
                    comboFlag = -1;
                    //handshake.position.y -= minusAmount;
                    player2!.size.height += CGFloat(inc);
                    player1!.size.height -= CGFloat(inc);
                    player2!.position.y -= CGFloat(inc/2);
                    player1!.position.y -= CGFloat(inc/2);
                    //minusAmount += inc;
                    
                    //increase player 1's tap count
                    p2_taps += 1;
                }
                
                //
                // Win Detection -- case for total victory
                // if player 1 wins
                if(player1!.size.height >= self.frame.height){
                    pOneDidWin = true;
                    displayWinner(pOneDidWin);
                }
                    // if player 2 wins
                else if(player2!.size.height >= self.frame.height){
                    pOneDidWin = false;
                    displayWinner(pOneDidWin);
                }
   
            }//end if
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
            
            // If game has yet to start
            if (!gameStarted)
            {
                // instruction & countdown
                preGameCountdown();
            }
            
            // If game has ended
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
            else {
                //
                // while game still in session, checks time passed
                if(timeSinceInit >= timeLimit){
                    gameChangeCountDown();
                }
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
            }else if (timeSinceInit<7){
                myLabel.text = "";
                gameStarted = true;
                inc = defaultInc;
            }
            
            myLabel.fontSize = 65;
        }
    }
    
    //
    // Countdown before changing game difficulty
    func gameChangeCountDown() {
            
        if (timeSinceInit < timeLimit+1){
            myLabel.text = "3";
        }else if (timeSinceInit < timeLimit+2){
            myLabel.text = "2";
        }else if (timeSinceInit < timeLimit+3){
            myLabel.text = "1";
        }else if (timeSinceInit < timeLimit+4){
            changeGameIntensity();
        }else if (timeSinceInit < timeLimit+10){
            // reset
            myLabel.text = "";
            timeSinceInit = 0.1;
        }
        
    }
    
    //
    // different game intensity changes
    func changeGameIntensity(){
        var intensity:Int = 1;
        switch(intensity){
            case 1:
                inc = 80;
                myLabel.text = "MORE POWER!";
                myLabel.fontSize = 40;
                break;
            default:
                inc = defaultInc;
                break;
        }
    }
    
    
    //
    // Deciding if a player has won
    func calcWinner(){
        if( p1_taps != p2_taps){
            pOneDidWin = (p1_taps > p2_taps) ? true:false;
            displayWinner(pOneDidWin);
        }else {
            displayWinner(pOneDidWin, tie: true);
        }

    }
    
    //
    // Display Who Won
    func displayWinner(pOneDidWin: Bool, tie: Bool = false){
        gameEnded = true;
        
        if(pOneDidWin){
            myLabel.text = "B L U E   W I N S !";
        }else{
            myLabel.text = "P I N K   W I N S !";
        }
        
        myLabel.fontSize = 25;
    }
    
    func delayedExit(currentTime: CFTimeInterval) {
        if ( (currentTime - exitTimer) > exitDuration)
        {
            if let gameOverCallback = gameOverDelegate {
                paused = true;
                gameOverCallback(didWin: pOneDidWin, p1TapCount: p1_taps, p2TapCount: p2_taps);
            }
            println("[GameScene] Game over");
        }
    }
}
