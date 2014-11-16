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
    var p1 :Player?
    var p2 :Player?
    var inc: Float = 35;
    var gap:CGFloat = 50; //point used for labels
    var topLabel = GameLabel(text: "WELCOME TO", fontSize: 18, position: CGPoint(x:0, y:0), alpha:0);
    var titleNode = SKNode();
    var fSize:CGFloat = 0.0;
    var botLabel1 = GameLabel(text: "TAP", fontSize: 0, fontName: "Avenir Black");
    var botLabel2 = GameLabel(text: "HERE", fontSize: 0, fontName: "Avenir Black");

    // Exit Setup
    typealias sequenceOverBlock = () -> Void
    var sequenceOverDelegate: sequenceOverBlock?
    // Flags, States, Timers
    var allStatesFinished:Bool = false;
    var exitStarted:Bool = false;
    var tapEnabled:Bool = false;
    
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
        // Bottom overlays top
        // and top stretches to fill da whole thing
        p2 = Player2(hex: 0xFF5D73, width: CGRectGetWidth(self.frame), height: CGRectGetHeight(self.frame));
        p2!.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame)/2);
        p2!.zPosition = 0;
        self.addChild(p2!);
        
        
        
        //bottom
        p1 = Player1(hex: 0x2D99EC, width: CGRectGetWidth(self.frame), height: CGRectGetHeight(self.frame)/2);
        p1!.position = CGPointMake(CGRectGetMidX(self.frame), 0 - CGRectGetHeight(self.frame)/2);
        p1!.zPosition = 1;
        self.addChild(p1!);
        
        // ALL the elements
        
        // Kickstart!
        updateState(); // -> initPhase1()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            // Game input
            if (tapEnabled && !allStatesFinished)
            {
                if (location.y < CGRectGetMidY(self.frame)) {
                    p1!.increase(inc);
                    //increase player 2's tap count
                    p1?.taps += 1;
                }
                
                // Finish detection
                if(p1!.size.height >= self.frame.height){
                    tapEnabled = false;
                    if (currentState == State.PHASE_3){
                        allStatesFinished = true;
                    } else {
                        updateState();
                    }
                    
                }
            }//end if
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if (!paused)
        {
            if (allStatesFinished && !exitStarted) {
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
            currentState = State.PHASE_1;
            initPhase1();
            break;
        case State.PHASE_1:
            currentState = State.PHASE_2;
            initPhase2();
            break;
        case State.PHASE_2:
            currentState = State.PHASE_3;
            initPhase3();
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
        println("initPhase1");
        var midpt = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)-(CGRectGetHeight(self.frame)/8)+gap);
        
        // WELCOME TO *******
        topLabel.position = midpt;
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
                self.topLabel.runAction(SKAction.fadeInWithDuration(0.3));
            }
            ]);
        
        
        // TAP OF WAR ********
        fSize = 45;
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
                self.titleNode.runAction(SKAction.fadeInWithDuration(0.3));
            }
            ]);
        
        //P1 position change ***************
        let yEffect = SKTMoveEffect(node: p1!, duration: 0.375, startPosition: p1!.position, endPosition: CGPointMake(p1!.position.x, CGRectGetHeight(p1!.frame)/2));
        yEffect.timingFunction = SKTTimingFunctionCircularEaseOut;
        var changeY = SKAction.actionWithEffect(yEffect);
        
        
        // BOTTOM PART ********
        // Tap here
        fSize = 15;
        midpt = CGPointMake(CGRectGetWidth(self.frame)/2, (CGRectGetHeight(self.frame)/3.5));
        botLabel1.fontSize = fSize+30;
        botLabel2.fontSize = fSize;
        botLabel1.position = midpt;
        botLabel2.position = CGPointMake(midpt.x, (midpt.y-(fSize+20+margin)) );
        botLabel1.alpha = 0;
        botLabel2.alpha = 0;
        botLabel1.zPosition = 2;
        botLabel2.zPosition = 2;
        
        self.addChild(botLabel1);
        self.addChild(botLabel2);
        
        // animation
        
        let botEffect1 = SKTScaleEffect(node: botLabel1, duration: 0.4, startScale: CGPointMake(0,0), endScale: CGPointMake(1,1));
        let botEffect2 = SKTScaleEffect(node: botLabel2, duration: 0.4, startScale: CGPointMake(0,0), endScale: CGPointMake(1,1));
        botEffect1.timingFunction = SKTTimingFunctionBackEaseOut;
        botEffect2.timingFunction = SKTTimingFunctionBackEaseOut;
        
        var botActions = SKAction.group([
            //SKAction.actionWithEffect(botEffect),
            SKAction.sequence([
                SKAction.runBlock{self.botLabel1.runAction(SKAction.fadeAlphaTo(1.0, duration: 0.0))},
                SKAction.actionWithEffect(botEffect1),
                ]),
            SKAction.sequence([
                SKAction.runBlock{self.botLabel2.runAction(SKAction.fadeAlphaTo(1.0, duration: 0.0))},
                SKAction.actionWithEffect(botEffect2),
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
        
        self.runAction(actions, completion: { () -> Void in
            // Callback
            self.tapEnabled = true;
            println("Phase1 Complete");
        });
    }
    
    /*------------------------------------------------------------------------------/
    PHASE 2: Your Side, Their Side. Don't cross your side!
    /-----------------------------------------------------------------------------*/
    func initPhase2(){
        println("initPhase2");
        // Reconfigure things from Phase 1
        // Hide shits
        topLabel.alpha = 0;
        titleNode.alpha = 0;
        // Reuse shits
        topLabel.text = "THEIR SIDE";
        topLabel.position = CGPoint(x: CGRectGetWidth(self.frame)/2, y: CGRectGetHeight(self.frame) * 3 / 4);
        
        var resetActions = SKAction.group([
            SKAction.sequence([
                // Shrink and move the player one down
                SKAction.runBlock{
                    let dur: NSTimeInterval = 0.4;
                    var tAction = SKAction.resizeToHeight( CGRectGetHeight(self.frame)/2, duration: dur);
                    tAction.timingMode = SKActionTimingMode.EaseOut;
                    self.p1!.runAction(tAction);
                    tAction = SKAction.moveToY( CGRectGetHeight(self.frame) * 1/4, duration: dur);
                    tAction.timingMode = SKActionTimingMode.EaseOut;
                    self.p1!.runAction(tAction);
                },
                // Fade out dat botlabels
                SKAction.runBlock{
                    self.botLabel1.runAction(SKAction.fadeAlphaTo(0.0, duration: 0.3), completion: { () -> Void in
                        self.botLabel1.text = "YOUR SIDE";
                        self.botLabel1.position = CGPoint(x: CGRectGetWidth(self.frame)/2, y: CGRectGetHeight(self.frame) / 4);
                    });
                    self.botLabel2.runAction(SKAction.fadeAlphaTo(0.0, duration: 0.3));
                }
            ]),
        ]);
        // Fade the two side labels
        var sideLabelActions = SKAction.group([
            SKAction.sequence([
                // Your Side first
                // Now Their Side
            ]),
        ]);
        
        
        // Full action sequence ***********
        var actions:SKAction = SKAction.sequence([
            SKAction.waitForDuration(0.6),
            resetActions
            ]);
        /* EXECUTE ACTIONS */
        self.runAction(actions, completion: { () -> Void in
            // Callback
            self.tapEnabled = true;
            println("Phase2 Complete");
        });
    }
    
    /*------------------------------------------------------------------------------/
    PHASE 3: Use as many fingers as you want
    /-----------------------------------------------------------------------------*/
    func initPhase3(){
        
    }
    
}