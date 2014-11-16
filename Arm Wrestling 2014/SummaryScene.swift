//
//  SummaryScene.swift
//  Arm Wrestling 2014
//
//  Created by Danny on 11/16/14.
//  Copyright (c) 2014 Teriyaki Studio. All rights reserved.
//

import SpriteKit

class SummaryScene: SKScene {
    init(size:CGSize, p1Win:Bool, p1Tap:Int, p2Tap:Int){
        super.init();
    }
    
    override init(size: CGSize) {
        super.init();
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}