//
//  Player1.swift
//  Arm Wrestling 2014
//
//  Created by Danny on 11/15/14.
//  Copyright (c) 2014 Teriyaki Studio. All rights reserved.
//

import SpriteKit

class Player1: Player{
    //
    // update size of rect
    /*------------------------------------------------------------------------------/
    increase: Increases size of rect (usually on tap) according to mode
    /-----------------------------------------------------------------------------*/
    override func increase(inc: Float) {
        self.size.height += CGFloat(inc);
        self.position.y += CGFloat(inc/2);
    }
    
    override func decrease(inc: Float) {
        self.size.height -= CGFloat(inc);
        self.position.y -= CGFloat(inc/2);
    }
}
