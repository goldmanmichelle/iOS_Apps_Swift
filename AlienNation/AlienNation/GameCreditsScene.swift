//
//  GameCreditsScene.swift
//  AlienNation
//
//  Created by Michelle Goldman on 6/11/15.
//  Copyright (c) 2015 Michelle Goldman. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation


class GameCreditsScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        
        //SET BACKGROUND//
        let background = SKSpriteNode(imageNamed: "creditscreen")
        background.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        //stretch out background to match device height
        background.size.height = self.frame.height
        
        self.addChild(background)
       
        
        //CREATE RETURN TO HOME SCREEN BUTTON//
        let homeScreenButton = SKSpriteNode(imageNamed: "homebtn")
        homeScreenButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-215)
        homeScreenButton.name = "returnhome"
        addChild(homeScreenButton)
        
     
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as? UITouch
        let touchLocation = touch!.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if(touchedNode.name == "returnhome"){
            let mainMenuScene = StartGameScene(size: size)
            mainMenuScene.scaleMode = scaleMode
            let transitionType = SKTransition.crossFadeWithDuration(2.0)
            view?.presentScene(mainMenuScene,transition: transitionType)
        }
    }

   
}
