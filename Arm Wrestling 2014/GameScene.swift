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
    let myLabel = SKLabelNode(fontNamed:"Avenir Heavy");
    var p1 :Player1?
    var p2 :Player2?
    var inc: Float = 0;
    var defaultInc:Float = 35;
    // Flow
    var timeLimit:CFTimeInterval = 15;
    var timeInitial:CFTimeInterval = 0;
    var timeSinceInit:CFTimeInterval = 0;
    let exitDuration:CFTimeInterval = 2;
    var exitTimer:CFTimeInterval = 0;
    var gameStarted:Bool = false;
    var gameEnded:Bool = false;
    var exitStarted:Bool = false;
    var pOneDidWin:Bool = false;
    
    enum Intensity{
        case DEFAULT_INT;
        case REVERSE_INT;
        case VERTICAL_INT;
    }
    
    var gameIntensity = Intensity.DEFAULT_INT;
    
    // Exit Setup
    typealias gameOverBlock = (didWin : Bool, p1TapCount: Int, p2TapCount: Int) -> Void
    var gameOverDelegate: gameOverBlock?

    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        myLabel.text = "GET READY!";
        myLabel.fontSize = 40;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-15);
        myLabel.zPosition = 100;
        self.addChild(myLabel)
        
        //bottom
        p1 = Player1(hex: 0x2D99EC, width: CGRectGetWidth(self.frame), height: CGRectGetHeight(self.frame)/2);
        p1!.position = CGPointMake(CGRectGetMidX(self.frame), (CGRectGetHeight(p1!.frame)/2));
        self.addChild(p1!)
        
        //top
        p2 = Player2(hex: 0xFF5D73, width: CGRectGetWidth(self.frame), height: CGRectGetHeight(self.frame)/2);
        p2!.position = CGPointMake(CGRectGetMidX(self.frame), (CGRectGetHeight(p1!.frame)*1.5));
        self.addChild(p2!)

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
                
                //
                // Win Detection -- case for total victory
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
                inc = defaultInc;
            }
            
            myLabel.fontSize = 40;
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
        }else if (timeSinceInit < timeLimit+10){
            // reset
            myLabel.text = "";
            //update timeInitial to restart interval
            timeInitial = 0;
        }
        
    }
    
    //
    // different game intensity changes
    func changeGameIntensity(){
        var intensity:Int = 1;
        switch(intensity){
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
                inc = defaultInc;
                break;
        }
    }
    
    //
    /* INTENSITIES */
    func initMorePower(){
        inc = 70;
        myLabel.text = "MORE POWER!";
        myLabel.fontSize = 40;
    }
    
    func initReverseReverse(){
        
    }
    
    func initVertical(){
        
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
                gameOverCallback(didWin: pOneDidWin, p1TapCount: p1!.taps, p2TapCount: p2!.taps);
            }
            println("[GameScene] Game over");
        }
    }
}
