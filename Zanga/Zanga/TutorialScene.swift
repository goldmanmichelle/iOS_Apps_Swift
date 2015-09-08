//
//  TutorialScene.swift
//  Zanga
//
//  Created by Michelle Goldman on 8/3/15.
//  Copyright (c) 2015 Michelle Goldman. All rights reserved.
//

import AVFoundation
import SpriteKit

class TutorialScene: SKScene {
    
    //MARK: Properties
    let background = SKSpriteNode(imageNamed: "TutorialBackground")
    let tutorialLabel = SKSpriteNode(imageNamed: "tutorial_label")
    let homeButton = SKSpriteNode(imageNamed: "home_button")
    let charactersLabel = SKLabelNode(fontNamed: "Marker Felt Wide")
    let instructionsLabel = SKLabelNode(fontNamed: "Marker Felt Wide")
    let hubertImage = SKSpriteNode(imageNamed: "hubert_sm")
    let hubertLabel = SKLabelNode(fontNamed: "Marker Felt Wide")
    let hubertInstruction = SKLabelNode(fontNamed: "Marker Felt Wide")
    let creatureBlueImage = SKSpriteNode(imageNamed: "creature_blue_sm")
    let creatureOrangeImage = SKSpriteNode(imageNamed: "creature_orange_sm")
    let frogMonsterImage = SKSpriteNode(imageNamed: "frog_monster_sm")
    let creatureLabel = SKLabelNode(fontNamed: "Marker Felt Wide")
    let creatureInstructions = SKLabelNode(fontNamed: "Marker Felt Wide")
    let mushroomImage = SKSpriteNode(imageNamed: "mushroom_hoody_sm")
    let mushroomLabel = SKLabelNode(fontNamed: "Marker Felt Wide")
    let mushroomInstructions = SKLabelNode(fontNamed: "Marker Felt Wide")
    
    //Screen Size
    var screenWidth = screenSize.width
    var screenHeight = screenSize.height
    var aspectRatio = screenSize.height / screenSize.width

    
    //MARK: Did Move to View
    override func didMoveToView(view: SKView) {
        
        //Set Background
        background.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        //stretch out background to match device height
        background.size.height = self.frame.height
        
        //Set Tutorial Label
        tutorialLabel.position = CGPointMake(screenSize.width/2, screenSize.height * 0.90)
        tutorialLabel.setScale(aspectRatio)
        
        //Set Characters Label
        charactersLabel.text = "CHARACTERS"
        charactersLabel.fontSize = 30
        charactersLabel.fontColor = SKColor.whiteColor()
        charactersLabel.position = CGPointMake(screenSize.width/2, screenSize.height * 0.74)
        charactersLabel.setScale(aspectRatio)
        
        //Set Hubert Label
        hubertLabel.text = "Hubert"
        hubertLabel.fontSize = 20
        hubertLabel.fontColor = SKColor.blackColor()
        hubertLabel.position = CGPointMake(screenSize.width * 0.22, screenSize.height * 0.65)
        hubertLabel.setScale(aspectRatio)
        
        //Set Hubert Image
        hubertImage.position = CGPointMake(screenSize.width * 0.22, screenSize.height * 0.60)
        hubertImage.setScale(aspectRatio)
        
        //Set Creatures Label
        creatureLabel.text = "Creatures"
        creatureLabel.fontSize = 20
        creatureLabel.fontColor = SKColor.blackColor()
        creatureLabel.position = CGPointMake(screenSize.width * 0.46, screenSize.height * 0.65)
        creatureLabel.setScale(aspectRatio)
        
        //Set Creature Images
        creatureBlueImage.position = CGPointMake(screenSize.width * 0.36, screenSize.height * 0.60)
        creatureBlueImage.setScale(aspectRatio)
        
        creatureOrangeImage.position = CGPointMake(screenSize.width * 0.46, screenSize.height * 0.60)
        creatureOrangeImage.setScale(aspectRatio)
        
        frogMonsterImage.position = CGPointMake(screenSize.width * 0.56, screenSize.height * 0.60)
        frogMonsterImage.setScale(aspectRatio)
        
        //Set Mushroom Label
        mushroomLabel.text = "Mushroom"
        mushroomLabel.fontSize = 20
        mushroomLabel.fontColor = SKColor.blackColor()
        mushroomLabel.position = CGPointMake(screenSize.width * 0.76, screenSize.height * 0.65)
        mushroomLabel.setScale(aspectRatio)
        
        //Set Mushroom Image
        mushroomImage.position = CGPointMake(screenSize.width * 0.76, screenSize.height * 0.60)
        mushroomImage.setScale(aspectRatio)
        
        //Set Instructions Label
        instructionsLabel.text = "GAME INSTRUCTIONS"
        instructionsLabel.fontSize = 30
        instructionsLabel.fontColor = SKColor.whiteColor()
        instructionsLabel.position = CGPointMake(screenSize.width/2, screenSize.height * 0.45)
        instructionsLabel.setScale(aspectRatio)
        
        //Set Hubert Instructions
        hubertInstruction.text = "1. Tap screen to make Hubert jump. Tap and hold for higher jumps."
        hubertInstruction.fontSize = 20
        hubertInstruction.fontColor = SKColor.blackColor()
        hubertInstruction.position = CGPointMake(screenSize.width/2, screenSize.height * 0.36)
        hubertInstruction.setScale(aspectRatio)
        
        //Set Creature Instructions
        creatureInstructions.text = "2. Avoid creatures to stay alive or it's game over."
        creatureInstructions.fontSize = 20
        creatureInstructions.fontColor = SKColor.blackColor()
        creatureInstructions.position = CGPointMake(screenSize.width/2, screenSize.height * 0.30)
        creatureInstructions.setScale(aspectRatio)
        
        //Set Mushroom Instructions
        mushroomInstructions.text = "3. Collect mushrooms to gain points."
        mushroomInstructions.fontSize = 20
        mushroomInstructions.fontColor = SKColor.blackColor()
        mushroomInstructions.position = CGPointMake(screenSize.width/2, screenSize.height * 0.24)
        mushroomInstructions.setScale(aspectRatio)
        
        //Set Home Button
        homeButton.position = CGPointMake(screenSize.width/2, screenSize.height * 0.13)
        homeButton.setScale(aspectRatio)
        homeButton.name = "homeButton"
        
        //Add Nodes to Scene
        self.addChild(background)
        self.addChild(tutorialLabel)
        self.addChild(charactersLabel)
        self.addChild(instructionsLabel)
        self.addChild(creatureBlueImage)
        self.addChild(creatureOrangeImage)
        self.addChild(frogMonsterImage)
        self.addChild(creatureLabel)
        self.addChild(creatureInstructions)
        self.addChild(mushroomImage)
        self.addChild(mushroomLabel)
        self.addChild(mushroomInstructions)
        self.addChild(hubertImage)
        self.addChild(hubertLabel)
        self.addChild(hubertInstruction)
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




