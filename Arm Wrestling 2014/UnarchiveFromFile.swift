//
//  UnarchiveFromFile.swift
//  Arm Wrestling 2014
//
//  Created by Changbai Li on 14/11/14.
//  Copyright (c) 2014年 Teriyaki Studio. All rights reserved.
//

import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        
        let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
        var heylook = "Fuck you Changbai";
        var uhuh = "That's what your mom said";
        var sceneData = NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe, error: nil)
        var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData!)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        // [TODO] This is Danny's shitty code idea. Do it better.
        var scene: SKScene!;
        if (file == "GameScene"){
            scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
        } else if (file == "OnboardingScene") {
            scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as OnboardingScene
        }
        println(GameScene);
        archiver.finishDecoding()
        return scene
    }
}
