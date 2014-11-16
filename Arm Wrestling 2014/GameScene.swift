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
    let myLabel = SKLabelNode(fontNamed:"Roboto-BlackItalic");
    let myLabel2 = SKLabelNode(fontNamed: "Roboto-Black");
    var game:SKSpriteNode?
    var p1 :Player1?
    var p2 :Player2?
    var inc: Float = 0;
    var defaultInc:Float?;
    // Flow
    var timeLimit:CFTimeInterval = 6;
    var timeInitial:CFTimeInterval = 0;
    var timeSinceInit:CFTimeInterval = 0;
    let exitDuration:CFTimeInterval = 2;
    var exitTimer:CFTimeInterval = 0;
    var gameStarted:Bool = false;
    var gameEnded:Bool = false;
    var exitStarted:Bool = false;
    var pOneDidWin:Bool = false;
    
    enum Intensity:Int{
        case DEFAULT = 0;
        case POWER;
        case REVERSE;
        case VERTICAL;
        case Total;
    }
    var reversed:Bool = false;
    var vertical:Bool = false;
    
    var currentIntensity = Intensity.DEFAULT;
    
    // Exit Setup
    typealias gameOverBlock = (didWin : Bool, p1TapCount: Int, p2TapCount: Int) -> Void
    var gameOverDelegate: gameOverBlock?

    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        // Main Game Node
        game = SKSpriteNode(color: UIColor.clearColor(), size: CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)))
        self.addChild(game!);
        game!.position = CGPoint(x:CGRectGetWidth(self.frame)/2, y:CGRectGetHeight(self.frame)/2);
        
        myLabel.text = "GET READY!";
        myLabel.fontSize = 40;
        myLabel.position = CGPoint(x:0, y:-15);
        myLabel.zPosition = 10;
        game!.addChild(myLabel)
        
        myLabel2.fontSize = myLabel.fontSize;
        myLabel2.position = myLabel.position;
        myLabel2.zPosition = myLabel.zPosition;
        game!.addChild(myLabel2)
        
        //bottom
        p1 = Player1(hex: 0x2D99EC, width: CGRectGetWidth(self.frame)*2, height: CGRectGetHeight(self.frame)/2);
        p1!.position = CGPointMake(0, (CGRectGetHeight(self.frame)/4*(-1)));
        game!.addChild(p1!)

        //top
        p2 = Player2(hex: 0xFF5D73, width: CGRectGetWidth(self.frame)*2, height: CGRectGetHeight(self.frame)/2);
        p2!.position = CGPointMake(0, (CGRectGetHeight(self.frame)/4));
        game!.addChild(p2!)
        
        defaultInc = Float(CGRectGetHeight(self.frame)/25);
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
    
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            // Game input
            if (gameStarted && !gameEnded)
            {
                
                if(reversed && !vertical){
                    if (location.y > CGRectGetMidY(self.frame)) {
                            p1!.increase(inc);
                            p2!.decrease(inc);
                            //increase player 2's tap count
                            p1?.taps += 1;
                    } else {
                            p2!.increase(inc);
                            p1!.decrease(inc);
                            //increase player 1's tap count
                            p2?.taps += 1;
                    }
                }
                    
                else if(!reversed && vertical){
                    if (location.x > CGRectGetMidX(self.frame)) {
                            p1!.increase(inc);
                            p2!.decrease(inc);
                            //increase player 2's tap count
                            p1?.taps += 1;
                    } else {
                            p2!.increase(inc);
                            p1!.decrease(inc);
                            //increase player 1's tap count
                            p2?.taps += 1;
                    }
                }
                
                else if(reversed && vertical){
                    if (location.x < CGRectGetMidX(self.frame)) {
                        p1!.increase(inc);
                        p2!.decrease(inc);
                        //increase player 2's tap count
                        p1?.taps += 1;
                    } else {
                        p2!.increase(inc);
                        p1!.decrease(inc);
                        //increase player 1's tap count
                        p2?.taps += 1;
                    }
                }
                    
                else{
                    if (location.y < CGRectGetMidY(self.frame)) {
                            p1!.increase(inc);
                            p2!.decrease(inc);
                            //increase player 2's tap count
                            p1?.taps += 1;
                    } else {
                            p2!.increase(inc);
                            p1!.decrease(inc);
                            //increase player 1's tap count
                            p2?.taps += 1;
                    }
                }
                
                checkWinner();
   
            }//end if
        }
    }
    
    // Win Detection -- case for total victory
    func checkWinner(){
        if(vertical){
            // if player 1 wins
            if(p1!.size.height >= self.frame.width){
                pOneDidWin = true;
                displayWinner(pOneDidWin);
            }
                // if player 2 wins
            else if(p2!.size.height >= self.frame.width){
                pOneDidWin = false;
                displayWinner(pOneDidWin);
            }
        }else{
            // if player 1 wins
            if(p1!.size.height >= self.frame.height){
                pOneDidWin = true;
                displayWinner(pOneDidWin);
            }
                // if player 2 wins
            else if(p2!.size.height >= self.frame.height){
                pOneDidWin = false;
                displayWinner(pOneDidWin);
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
                    //println(timeSinceInit);
                    intensityChangeCount();
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
                inc = defaultInc!;
            }
            
            
        }
    }
    
    //
    // Countdown before changing game difficulty
    func intensityChangeCount() {
            
        if (timeSinceInit < timeLimit+1){
            myLabel.text = "3";
        }else if (timeSinceInit < timeLimit+2){
            myLabel.text = "2";
        }else if (timeSinceInit < timeLimit+3){
            myLabel.text = "1";
        }else if (timeSinceInit < timeLimit+4){
            changeGameIntensity();
            // reset
            //update timeInitial to restart interval
            timeInitial = 0;
        }
        
    }
    
    //
    // different game intensity changes
    func changeGameIntensity(){
        //change to randomw intensity
        var num = arc4random()%UInt32(Intensity.Total.rawValue)+1;
        
        switch(num){
            case 1:
                initMorePower();
                break;
            case 2:
                initReverseReverse();
                break;
            case 3:
                initVertical();
                break;
            default:
                initMorePower();
                break;
        }
        
        var clearLabel = SKAction.sequence([
                SKAction.waitForDuration(1),
                SKAction.runBlock{
                    self.myLabel.text = "";
                    self.myLabel.position = CGPoint(x:0, y:-15);
                    self.myLabel2.text = "";
                }
            ]);
        
        myLabel.runAction(clearLabel);
    }
    
    //
    /* INTENSITIES */
    func initMorePower(){
        inc += 30;
        myLabel.text = "MORE POWER!";
        myLabel.fontSize = 40;
        
        currentIntensity = Intensity.POWER;
    }
    
    func initReverseReverse(){
        myLabel.text = "REVERSE";
        myLabel.position = CGPoint(x:0, y:30);
        myLabel2.runAction(SKAction.rotateByAngle(CGFloat(M_PI), duration: 0.01));
        myLabel2.text = "REVERSE";
        myLabel2.position = CGPoint(x:0, y:-30);
        var rotate = SKAction.rotateByAngle(CGFloat(M_PI), duration: 0.2);
        game!.runAction(rotate);
        
        currentIntensity = (currentIntensity != Intensity.REVERSE) ? Intensity.REVERSE:Intensity.DEFAULT;
        reversed = (currentIntensity == Intensity.REVERSE) ? true:false;
    }
    
    func initVertical(){
        myLabel.text = "OH";
        myLabel.position = CGPoint(x:0, y:(CGRectGetHeight(self.frame)/8));
        myLabel2.text = "NO!";
        myLabel2.position = CGPoint(x:0, y:(CGRectGetHeight(self.frame)/8)*(-1));
        var deg:CGFloat;
        
        if(!vertical){
            p1!.size.height = CGRectGetWidth(self.frame)/2;
            p2!.size.height = CGRectGetWidth(self.frame)/2;
            p1!.position = CGPointMake(0, (CGRectGetWidth(self.frame)/4*(-1)));
            p2!.position = CGPointMake(0, (CGRectGetWidth(self.frame)/4));
            currentIntensity = Intensity.VERTICAL;
            vertical = true;
            deg = CGFloat(M_PI/2);
            myLabel.zRotation = CGFloat(M_PI/2)*(-1);
            myLabel2.zRotation = CGFloat(M_PI/2)*(-1);
        }else {
            p1!.size.height = CGRectGetHeight(self.frame)/2;
            p2!.size.height = CGRectGetHeight(self.frame)/2;
            p1!.position = CGPointMake(0, (CGRectGetHeight(self.frame)/4*(-1)));
            p2!.position = CGPointMake(0, (CGRectGetHeight(self.frame)/4));
            currentIntensity = Intensity.DEFAULT;
            vertical = false;
            deg = CGFloat(M_PI/2)*(-1);
            myLabel.zRotation = CGFloat(0);
            myLabel2.zRotation = CGFloat(0);
        }
        var rotate = SKAction.rotateByAngle(deg, duration: 0.2);
        game!.runAction(rotate);
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
        
        myLabel.fontSize = 30;
    }
    
    func delayedExit(currentTime: CFTimeInterval) {
        if ( (currentTime - exitTimer) > exitDuration)
        {
            if let gameOverCallback = gameOverDelegate {
                paused = true;
                gameOverCallback(didWin: pOneDidWin, p1TapCount: p1!.taps, p2TapCount: p2!.taps);
            }
            println("[GameScene] Game over");
        }
    }
}
