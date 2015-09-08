//
//  GameOverScene.swift
//  AlienNation
//
//  Created by Michelle Goldman on 6/17/15.
//  Copyright (c) 2015 Michelle Goldman. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

//LOAD SOUND EFFECT FILES//
let gameOverSound = SKAction.playSoundFileNamed("gameover.wav", waitForCompletion: false)

class GameOverScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.blackColor()
        NSLog("GAME OVER SCREEN LOADED!")
        
        runAction(SKAction.playSoundFileNamed("gameover.wav", waitForCompletion: false))
        
        //CREATE GAME TITLE//
        let titleLabel = SKLabelNode(fontNamed: "Futura")
        titleLabel.text = "GAME"
        titleLabel.fontSize = 70
        titleLabel.color = UIColor.purpleColor()
        titleLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)+200)
        self.addChild(titleLabel)
        
        let titleLabel2 = SKLabelNode(fontNamed: "Futura")
        titleLabel2.text = "OVER"
        titleLabel2.fontSize = 70
        titleLabel2.color = UIColor.purpleColor()
        titleLabel2.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)+100)
        self.addChild(titleLabel2)
        
        
        //CREATE PLAY AGAIN BUTTON//
        let playAgainGameButton = SKSpriteNode(imageNamed: "playagainbtn")
        playAgainGameButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        playAgainGameButton.name = "playagain"
        addChild(playAgainGameButton)
        
        //CREATE FINISHED PLAYING BUTTON//
        let finishedPlayingGameButton = SKSpriteNode(imageNamed: "endgamebtn")
        finishedPlayingGameButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-100)
        finishedPlayingGameButton.name = "finishedplaying"
        addChild(finishedPlayingGameButton)
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as? UITouch
        let touchLocation = touch!.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if(touchedNode.name == "playagain"){
            let newGameScene = GameScene(size: size)
            newGameScene.scaleMode = scaleMode
            let transitionType = SKTransition.crossFadeWithDuration(1.0)
            view?.presentScene(newGameScene,transition: transitionType)
        } else if(touchedNode.name == "finishedplaying"){
            let mainMenuScene = StartGameScene(size: size)
            mainMenuScene.scaleMode = scaleMode
            let transitionType = SKTransition.crossFadeWithDuration(1.0)
            view?.presentScene(mainMenuScene,transition: transitionType)
        }
    }
    
}
