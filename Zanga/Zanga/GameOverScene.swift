//
//  GameOverScene.swift
//  Zanga
//
//  Created by Michelle Goldman on 8/3/15.
//  Copyright (c) 2015 Michelle Goldman. All rights reserved.
//

import AVFoundation
import SpriteKit

class GameOverScene: SKScene {
    
    //MARK: Properties
    let background = SKSpriteNode(imageNamed: "GameOverBackground")
    let gameOverLabel = SKLabelNode(fontNamed: "Marker Felt Wide")
    let playAgainButton = SKSpriteNode(imageNamed: "play_again_button")
    let creditsButton = SKSpriteNode(imageNamed: "credits_button")

    //Set Color for Win/Lose Text
    let greenColor = SKColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0)
    
    //Screen Size
    var screenWidth = screenSize.width
    var screenHeight = screenSize.height
    var aspectRatio = screenSize.height / screenSize.width
 
    init(size: CGSize, won: Bool) {
        super.init(size: size)
        
        //Set Game Over Label
        gameOverLabel.text = (won ? "You Win!" : "Nice Try!")
        gameOverLabel.fontSize = 60
        gameOverLabel.fontColor =
            (won ? greenColor : SKColor.purpleColor())
        gameOverLabel.position = CGPointMake(screenSize.width/2, screenSize.height * 0.60)
        gameOverLabel.setScale(aspectRatio)
        
        
        //Add Nodes to Scene
        self.addChild(gameOverLabel)
    }
    
    //MARK: Required Init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Did Move to View
    override func didMoveToView(view: SKView) {
        //Set Background
        background.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        //stretch out background to match device height
        background.size.height = self.frame.height
        
        //Set Credits Button
        creditsButton.position = CGPointMake(screenSize.width/2, screenSize.height * 0.15)
        creditsButton.setScale(aspectRatio)
        creditsButton.name = "creditsButton"
        
        //Set Play Again Button
        playAgainButton.position = CGPointMake(screenSize.width/2, screenSize.height * 0.35)
        playAgainButton.setScale(aspectRatio)
        playAgainButton.name = "playAgainButton"
        
        //Add Nodes to Scene
        self.addChild(background)
        self.addChild(creditsButton)
        self.addChild(playAgainButton)
    }
    
    
    //MARK: Touches Began
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
 
        let touch = touches.first as? UITouch
        let touchLocation = touch!.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if (touchedNode.name == "playAgainButton") {
            let gameScene = GameScene(size: size)
            gameScene.scaleMode = .ResizeFill
            let transitionType = SKTransition.crossFadeWithDuration(1.0)
            view?.presentScene(gameScene,transition: transitionType)
        } else if (touchedNode.name == "creditsButton") {
            let creditsScene = CreditsScene(size: self.size)
            creditsScene.scaleMode = .AspectFill
            let transitionType = SKTransition.crossFadeWithDuration(1.0)
            view?.presentScene(creditsScene,transition: transitionType)
        }
    }
}


