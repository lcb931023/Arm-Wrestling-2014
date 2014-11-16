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
    var topNode:SKNode?, botNode:SKNode?, midNode:SKNode?;
    var p1 :Player?
    var p2 :Player?
    var inc: Float = 35;
    // Exit Setup
    typealias sequenceOverBlock = () -> Void
    var sequenceOverDelegate: sequenceOverBlock?
    // Flags, States, Timers
    var stateEnded:Bool = false;
    var exitStarted:Bool = false;
    var startTap:Bool = false;
    
    enum State {
        case INITIAL;
        case PHASE_1;
        case PHASE_2;
        case PHASE_3;
    }
    
    var currentState:State = State.INITIAL;
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //top
        p2 = Player2(hex: 0xFF5D73, width: CGRectGetWidth(self.frame), height: CGRectGetHeight(self.frame));
        p2!.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame)/2);
        self.addChild(p2!);
        
        //bottom
        p1 = Player1(hex: 0x2D99EC, width: CGRectGetWidth(self.frame), height: CGRectGetHeight(self.frame)/2);
        p1!.position = CGPointMake(CGRectGetMidX(self.frame), 0 - CGRectGetHeight(self.frame)/2);
        self.addChild(p1!);
        
        updateState();
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            // Game input
            if (startTap && !stateEnded)
            {
                if (location.y < CGRectGetMidY(self.frame)) {
                    p1!.increase(inc);
                    p2!.decrease(inc);
                    //increase player 2's tap count
                    p1?.taps += 1;
                }
                
                // Finish detection
                if(p1!.size.height >= self.frame.height){
                    stateEnded = true;
                }
            }//end if
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if (!paused)
        {
            if (stateEnded && !exitStarted) {
                if let sequenceOverCallback = sequenceOverDelegate {
                    paused = true;
                    sequenceOverCallback();
                    exitStarted = true;
                }
            }
        }
    }
    
    //
    /*------------------------------------------------------------------------------/
    updateState: updates current Sate of onboarding screen
    /-----------------------------------------------------------------------------*/
    func updateState(){
        //moves to next state
        switch(currentState){
        case State.INITIAL:
            initPhase1();
            break;
        case State.PHASE_1:
            break;
        case State.PHASE_2:
            break;
        case State.PHASE_3:
            break;
        default:
            break;
        }
    }
    
    //
    // PHASES
    
    /*------------------------------------------------------------------------------/
    PHASE 1: User is prompted to tap on his side until his side wins
    /-----------------------------------------------------------------------------*/
    func initPhase1(){
        //point used for labels
        var gap:CGFloat = 50;
        var midpt = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)-(CGRectGetHeight(self.frame)/8)+gap);
        
        // WELCOME TO *******
        var topLabel = GameLabel(text: "WELCOME TO", fontSize: 18, position: midpt, alpha:0);
        self.addChild(topLabel);
        
        // toplabel animation setup
        let topEffect = SKTMoveEffect(node: topLabel,
            duration: 0.4,
            startPosition: topLabel.position,
            endPosition: CGPointMake(topLabel.position.x, topLabel.position.y-gap)
        );
        topEffect.timingFunction = SKTTimingFunctionCircularEaseOut;
        //action var
        var topLabelActions = SKAction.group([
            SKAction.actionWithEffect(topEffect),
            SKAction.runBlock{
                topLabel.runAction(SKAction.fadeInWithDuration(0.3));
            }
            ]);
        
        
        // TAP OF WAR ********
        var titleNode = SKNode();
        var fSize:CGFloat = 45;
        let margin:CGFloat = 5;
        let distance = CGRectGetHeight(self.frame)/9;
        var label1 = GameLabel(text:"TAP", fontSize: fSize, position:CGPointMake(midpt.x, midpt.y-distance), fontName: "Avenir Black");
        var label2 = GameLabel(text:"OF", fontSize: fSize, position:CGPointMake(midpt.x, (midpt.y-(distance+fSize+margin))), fontName: "Avenir Black");
        var label3 = GameLabel(text:"WAR", fontSize: fSize, position:CGPointMake(midpt.x, (midpt.y-(distance+fSize*2+margin))), fontName: "Avenir Black");
        
        titleNode.addChild(label1);
        titleNode.addChild(label2);
        titleNode.addChild(label3);
        titleNode.alpha = 0;
        self.addChild(titleNode);
        
        // title node animation setup
        let titleEffect = SKTMoveEffect(node: titleNode,
            duration: 0.4,
            startPosition: titleNode.position,
            endPosition: CGPointMake(titleNode.position.x, titleNode.position.y-gap)
        );
        titleEffect.timingFunction = SKTTimingFunctionCircularEaseOut;
        //action var
        var titleActions = SKAction.group([
            SKAction.actionWithEffect(titleEffect),
            SKAction.runBlock{
                titleNode.runAction(SKAction.fadeInWithDuration(0.3));
            }
            ]);
        
        
        
        //P1 position change ***************
        let yEffect = SKTMoveEffect(node: p1!, duration: 0.375, startPosition: p1!.position, endPosition: CGPointMake(p1!.position.x, CGRectGetHeight(p1!.frame)/2));
        yEffect.timingFunction = SKTTimingFunctionCircularEaseOut;
        var changeY = SKAction.actionWithEffect(yEffect);
        
        
        // BOTTOM PART ********
        // Tap here
        var bottomNode = SKNode();
        fSize = 15;
        midpt = CGPointMake(CGRectGetWidth(self.frame)/2, (CGRectGetHeight(self.frame)/3.5));
        label1 = GameLabel(text: "TAP", fontSize: fSize+30, position:midpt, fontName: "Avenir Black");
        label2 = GameLabel(text: "HERE", fontSize: fSize, position:CGPointMake(midpt.x, (midpt.y-(fSize+20+margin)) ) );
        bottomNode.addChild(label1);
        bottomNode.addChild(label2);
        bottomNode.alpha = 0;
        bottomNode.zPosition = 2;
        self.addChild(bottomNode);
        
        // animation
        var scale = SKAction.scaleTo(1.5, duration: 0.3);
        /*//
        
        CHANGBAI LI -- GET THE "TAP HERE" TO POP UP
        
        *///
        let botEffect = SKTScaleEffect(node: bottomNode, duration: 0.4, startScale: CGPointMake(0,1), endScale: CGPointMake(1.5,1));
        botEffect.timingFunction = SKTTimingFunctionBackEaseOut;
        var botActions = SKAction.group([
            //SKAction.actionWithEffect(botEffect),
            SKAction.sequence([
                SKAction.runBlock{bottomNode.runAction(SKAction.fadeInWithDuration(0.3))},
                SKAction.runBlock{bottomNode.runAction(SKAction.scaleTo(3, duration: 0.2))},
                ])
            ]);
        
        
        //
        // Full action sequence ***********
        var actions:SKAction = SKAction.sequence([
            SKAction.waitForDuration(0.6),
            changeY,
            SKAction.waitForDuration(0.5),
            topLabelActions,
            titleActions,
            SKAction.waitForDuration(0.25),
            botActions
            ]);
        
        
        
        /* EXECUTE ACTIONS */
        self.runAction(actions, completion: { () -> Void in
            self.startTap = true;
            self.p1!.zPosition = 1;
            println("StartTap");
        });
    }
    
}