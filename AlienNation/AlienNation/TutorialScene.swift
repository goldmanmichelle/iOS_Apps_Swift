//
//  TutorialScene.swift
//  AlienNation
//
//  Created by Michelle Goldman on 6/22/15.
//  Copyright (c) 2015 Michelle Goldman. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation


class TutorialScene: SKScene {
  
    override func didMoveToView(view: SKView) {
        
        //SET BACKGROUND//
        let background = SKSpriteNode(imageNamed: "tutorial")
        //background = SKSpriteNode(texture: backgroundTexture)
        background.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        //stretch out background to match device height
        background.size.height = self.frame.height
        
        self.addChild(background)
        
        //CREATE START GAME BUTTON//
        let startGameButton = SKSpriteNode(imageNamed: "startgamebtn")
        startGameButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-175)
        startGameButton.name = "startgame"
        startGameButton.zPosition = 2
        addChild(startGameButton)
        
        //CREATE RETURN TO HOME SCREEN BUTTON//
        let homeScreenButton = SKSpriteNode(imageNamed: "homebtn")
        homeScreenButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-250)
        homeScreenButton.name = "returnhome"
        addChild(homeScreenButton)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as? UITouch
        let touchLocation = touch!.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if(touchedNode.name == "startgame"){
            runAction(SKAction.playSoundFileNamed("startgame.wav", waitForCompletion: false))
            let newGameScene = GameScene(size: size)
            newGameScene.scaleMode = scaleMode
            let transitionType = SKTransition.crossFadeWithDuration(2.0)
            view?.presentScene(newGameScene,transition: transitionType)
        } else if(touchedNode.name == "returnhome"){
            let newGameScene = StartGameScene(size: size)
            newGameScene.scaleMode = scaleMode
            let transitionType = SKTransition.crossFadeWithDuration(2.0)
            view?.presentScene(newGameScene,transition: transitionType)
        }
    }
}
