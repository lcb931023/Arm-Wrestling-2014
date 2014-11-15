//
//  Player.swift
//  Arm Wrestling 2014
//
//  Created by Danny on 11/15/14.
//  Copyright (c) 2014 Teriyaki Studio. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    var taps:Int = 0;
    
    init(hex:Int, width:CGFloat, height:CGFloat){
        super.init();
        self.color = colorize(hex, alpha:1.0);
        self.size = CGSizeMake( width, height);
    }
    
    /*------------------------------------------------------------------------------/
       Ovverriding SKSpriteNode designated initializer -> not required
    /-----------------------------------------------------------------------------*/
    override init(texture: SKTexture!, color:UIColor!, size:(CGSize!))
    {
        super.init(texture: texture, color: color, size: size);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func colorize (hex: Int, alpha: Double = 1.0) -> UIColor {
        //gets hex and converts to rgb values 0.0 - 1.0
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        var color: UIColor = UIColor( red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha:CGFloat(alpha) )
        return color
    }
    
    //
    // update size of rect
    /*------------------------------------------------------------------------------/
       increase: Increases size of rect (usually on tap) according to mode
    /-----------------------------------------------------------------------------*/
    func increase(inc:Float){}
    
    /*------------------------------------------------------------------------------/
        decrease: Increases size of rect (usually on tap) according to mode
    /-----------------------------------------------------------------------------*/
    func decrease(inc:Float){}
    
}