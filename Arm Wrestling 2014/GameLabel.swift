//
//  GameLabel.swift
//  Arm Wrestling 2014
//
//  Created by Danny on 11/15/14.
//  Copyright (c) 2014 Teriyaki Studio. All rights reserved.
//

import SpriteKit

class GameLabel: SKLabelNode {
    
    init (text:String, fontSize:CGFloat, position:CGPoint = CGPointMake(0,0), alpha:CGFloat = 1,fontName:String = "Roboto-Black"){
        super.init();
        self.fontName = fontName;
        self.text = text;
        self.fontSize = fontSize;
        self.alpha = alpha;
        self.position = position;
    }
    
    override init(){
        super.init();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
