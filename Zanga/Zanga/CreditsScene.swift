//
//  CreditsScene.swift
//  Zanga
//
//  Created by Michelle Goldman on 8/25/15.
//  Copyright (c) 2015 Michelle Goldman. All rights reserved.
//

import AVFoundation
import SpriteKit

class CreditsScene: SKScene {
   
    //MARK: Properties
    let creditsLabel = SKSpriteNode(imageNamed: "credits_label")
    let homeButton = SKSpriteNode(imageNamed: "home_button")
    let musicByLabel = SKLabelNode(fontNamed: "Marker Felt Wide")
    let musicByContent = SKLabelNode(fontNamed: "Marker Felt Wide")
    let artworkByLabel = SKLabelNode(fontNamed: "Marker Felt Wide")
    let artworkByContent = SKLabelNode(fontNamed: "Marker Felt Wide")
    let specialThanksLabel1 = SKLabelNode(fontNamed: "Marker Felt Wide")
    let specialThanksLabel2 = SKLabelNode(fontNamed: "Marker Felt Wide")
    let developedByLabel = SKLabelNode(fontNamed: "Marker Felt Wide")
    let developedByContent = SKLabelNode(fontNamed: "Marker Felt Wide")

    
    //Screen Size
    var screenWidth = screenSize.width
    var screenHeight = screenSize.height
    var aspectRatio = screenSize.height / screenSize.width
    
    //MARK: Did Move to View
    override func didMoveToView(view: SKView) {
        
        //Set Background
        let background = SKSpriteNode(imageNamed: "CreditsBackground")
        background.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        //stretch out background to match device height
        background.size.height = self.frame.height
        
        //Set Credits Label
        creditsLabel.position = CGPointMake(screenSize.width/2, screenSize.height * 0.90)
        creditsLabel.setScale(aspectRatio)
        
        //Set Developed By Label
        developedByLabel.text = "Developed By"
        developedByLabel.fontSize = 20
        developedByLabel.fontColor = SKColor.whiteColor()
        developedByLabel.position = CGPointMake(screenSize.width/2, screenSize.height * 0.75)
        developedByLabel.setScale(aspectRatio)
        
        //Set Developed By Content
        developedByContent.text = "Michelle Goldman"
        developedByContent.fontSize = 30
        developedByContent.fontColor = SKColor.whiteColor()
        developedByContent.position = CGPointMake(screenSize.width/2, screenSize.height * 0.71)
        developedByContent.setScale(aspectRatio)
        
        //Set Music By Label
        musicByLabel.text = "Music By"
        musicByLabel.fontSize = 20
        musicByLabel.fontColor = SKColor.whiteColor()
        musicByLabel.position = CGPointMake(screenSize.width/2, screenSize.height * 0.66)
        musicByLabel.setScale(aspectRatio)
        
        //Set Music By Content
        musicByContent.text = "\"Make It Fun\" by Jeremy Harris, complements of Westar Music."
        musicByContent.fontSize = 30
        musicByContent.fontColor = SKColor.whiteColor()
        musicByContent.position = CGPointMake(screenSize.width/2, screenSize.height * 0.62)
        musicByContent.setScale(aspectRatio)
        
        //Set Artwork By Label
        artworkByLabel.text = "Artwork By"
        artworkByLabel.fontSize = 20
        artworkByLabel.fontColor = SKColor.whiteColor()
        artworkByLabel.position = CGPointMake(screenSize.width/2, screenSize.height * 0.57)
        artworkByLabel.setScale(aspectRatio)
        
        //Set Artwork By Content
        artworkByContent.text = "All artwork is complements of OpenGameArt.org."
        artworkByContent.fontSize = 30
        artworkByContent.fontColor = SKColor.whiteColor()
        artworkByContent.position = CGPointMake(screenSize.width/2, screenSize.height * 0.53)
        artworkByContent.setScale(aspectRatio)
        
        //Set Special Thanks Label
        specialThanksLabel1.text = "* Special thank you to Gabby Goldman for choosing"
        specialThanksLabel1.fontSize = 35
        specialThanksLabel1.fontColor = SKColor.purpleColor()
        specialThanksLabel1.position = CGPointMake(screenSize.width/2, screenSize.height * 0.43)
        specialThanksLabel1.setScale(aspectRatio)
        
        //Set Special Thanks Label
        specialThanksLabel2.text = "just the right game background music!"
        specialThanksLabel2.fontSize = 35
        specialThanksLabel2.fontColor = SKColor.purpleColor()
        specialThanksLabel2.position = CGPointMake(screenSize.width/2, screenSize.height * 0.39)
        specialThanksLabel2.setScale(aspectRatio)
        
        //Set Home Button
        homeButton.position = CGPointMake(screenSize.width/2, screenSize.height * 0.11)
        homeButton.setScale(aspectRatio)
        homeButton.name = "homeButton"
        
        //Add Nodes to Scene
        self.addChild(background)
        self.addChild(creditsLabel)
        self.addChild(developedByLabel)
        self.addChild(developedByContent)
        self.addChild(musicByLabel)
        self.addChild(musicByContent)
        self.addChild(artworkByLabel)
        self.addChild(artworkByContent)
        self.addChild(specialThanksLabel1)
        self.addChild(specialThanksLabel2)
        self.addChild(homeButton)
    }
    
    //MARK: Touches Began
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as? UITouch
        let touchLocation = touch!.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if (touchedNode.name == "homeButton") {
            let gameScene = GameScene(size: size)
            gameScene.scaleMode = .ResizeFill
            let transitionType = SKTransition.crossFadeWithDuration(1.0)
            view?.presentScene(gameScene,transition: transitionType)
        }
    }

    
}