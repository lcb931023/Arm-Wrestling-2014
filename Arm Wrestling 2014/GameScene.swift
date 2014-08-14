//
//  GameScene.swift
//  Arm Wrestling 2014
//
//  Created by Changbai Li & Danny Nguyen on 14-7-12.
//  Copyright (c) 2014年 Teriyaki Studio. All rights reserved.
//

import SpriteKit

let handshake = SKSpriteNode(imageNamed: "handshake_T")
var comboFlag = 0;
var plusAmount:Float = 15;
var minusAmount:Float = 15;
let myLabel = SKLabelNode(fontNamed:"HelveticaNeue");

var timeInitial:CFTimeInterval = 0;
var timeSinceInit:CFTimeInterval = 0;
var gameStarted:Bool = false;
var gameEnded:Bool = false;

var player1 :SKSpriteNode?
var player2 :SKSpriteNode?

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        handshake.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(handshake)
        
        myLabel.text = "Tap your side of screen to wrestle!";
        myLabel.fontSize = 25;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        myLabel.zPosition = 100;
        self.addChild(myLabel)
        
        
        
        player1 = createRect(0xFC4D4D);
        self.addChild(player1)
        
        
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
                    gameEnded = true;
                }
                else if(handshake.position.y >= CGRectGetHeight(self.frame)){
                    myLabel.text = "Player 2 Wins!";
                    gameEnded = true;
                }
                else{
                    myLabel.text = "";
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
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
}
