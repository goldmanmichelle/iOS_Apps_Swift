//
//  GameScene.swift
//  Zanga
//
//  Created by Michelle Goldman on 8/3/15.
//  Copyright (c) 2015 Michelle Goldman. All rights reserved.
//

//import UIKit
import SpriteKit
import AVFoundation

//Create Fire & Fireflies Textures
var fire : SKSpriteNode!
var fireMovement : [SKTexture]!
var fireflies : SKSpriteNode!
var firefliesMovement : [SKTexture]!


class GameScene: SKScene {
    
    //MARK: Properties
    let gameTitle = SKSpriteNode(imageNamed: "game_title_sign")
    let hubert = SKSpriteNode(imageNamed: "hubert")
    let playButton = SKSpriteNode(imageNamed:"play_button")
    let tutorialButton = SKSpriteNode(imageNamed: "tutorial_button")
    
    //Screen Size
    var screenWidth = screenSize.width
    var screenHeight = screenSize.height
    var aspectRatio = screenSize.height / screenSize.width
    
    //Create Play Button Color Change
    let changePlayButtonColor = SKAction.colorizeWithColor(SKColor.blueColor(), colorBlendFactor: 0.3, duration: 2)
    let changePlayButtonColor2 = SKAction.waitForDuration(1)
    let changePlayButtonColor3 = SKAction.colorizeWithColorBlendFactor(0.0, duration: 3)
    
    
    
    //MARK: Did Move To View
    override func didMoveToView(view: SKView) {
        
        //Play Game Music
        playBackgroundMusic("gamemusic.mp3")
        
        //Set Up Fire Texture Atlas for Animation
        let fireAnimatedAtlas = SKTextureAtlas(named: "fireSpritesheet")
        var moveFrames1 = [SKTexture]()
        
        let numImages1 = fireAnimatedAtlas.textureNames.count
        for var i=1; i<=numImages1/2; i++ {
            let fireTextureName = "fire\(i)"
            moveFrames1.append(fireAnimatedAtlas.textureNamed(fireTextureName))
        }
        fireMovement = moveFrames1
        
        let firstFrame1 = fireMovement[0]
        fire = SKSpriteNode(texture: firstFrame1)
        fire.position = CGPointMake(screenSize.width * 0.35, screenSize.height * 0.71)
        //fire.setScale(aspectRatio)
        fire.zPosition = 1
        self.addChild(fire)
        
        animateFire()
        
        //Set Up Fireflies Texture Atlas for Animation
        let firefliesAnimatedAtlas = SKTextureAtlas(named: "firefliesSpritesheet")
        var moveFrames2 = [SKTexture]()

        let numImages2 = fireAnimatedAtlas.textureNames.count
        for var i=1; i<=numImages2/2; i++ {
            let firefliesTextureName = "fireflies\(i)"
            moveFrames2.append(firefliesAnimatedAtlas.textureNamed(firefliesTextureName))
        }
        firefliesMovement = moveFrames2
        
        let firstFrame2 = firefliesMovement[0]
        fireflies = SKSpriteNode(texture: firstFrame2)
        fireflies.position = CGPointMake(screenSize.width * 0.35, screenSize.height * 0.71)
        //fireflies.setScale(aspectRatio)
        fireflies.zPosition = 1
        self.addChild(fireflies)
        
        animateFireflies()
        

        //Set Background
        let background = SKSpriteNode(imageNamed: "StartingBackground2")
        background.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        //stretch out background to match device height
        background.size.height = self.frame.height
        
        //Set Game Title
        gameTitle.position = CGPointMake(screenSize.width/2, screenSize.height * 0.80)
        gameTitle.setScale(aspectRatio)
        
        //Set Hubert
        hubert.position = CGPointMake(screenSize.width * 0.70, screenSize.height * 0.86)
        hubert.setScale(aspectRatio)
        hubert.zPosition = 1
        
        //Set Play Button
        playButton.position = CGPointMake(screenSize.width/2, screenSize.height * 0.45)
        playButton.setScale(aspectRatio)
        playButton.name = "playbutton"
        
        //Set Tutorial Button
        tutorialButton.position = CGPointMake(screenSize.width/2, screenSize.height * 0.15)
        tutorialButton.setScale(aspectRatio)
        tutorialButton.name = "tutorialbutton"
        
        //Add Nodes to Scene
        self.addChild(background)
        self.addChild(gameTitle)
        self.addChild(hubert)
        self.addChild(playButton)
        self.addChild(tutorialButton)
        
        //Change Play Button Color (effect)
        playButton.runAction (
            SKAction.repeatActionForever (
                SKAction.sequence([changePlayButtonColor, changePlayButtonColor2, changePlayButtonColor3]))
        )
     
    }
    
    //MARK: Animate Fire
    func animateFire() {
        fire.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(fireMovement, timePerFrame: 0.3, resize: false, restore: true)), withKey:"animatingFire")
    }
    
    //MARK: Animate Fireflies
    func animateFireflies() {
        fireflies.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(firefliesMovement, timePerFrame: 0.3, resize: false, restore: true)), withKey:"animatingFire")
    }
    
    //MARK: Touches Began
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as? UITouch
        let touchLocation = touch!.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
            
            if (touchedNode.name == "playbutton") {
                startgameSound.play()
                let gamePlayScene = GamePlayScene(size: self.size)
                gamePlayScene.scaleMode = .ResizeFill
                let transitionType = SKTransition.crossFadeWithDuration(1.0)
                view?.presentScene(gamePlayScene,transition: transitionType)
            } else if (touchedNode.name == "tutorialbutton") {
                let tutorialScene = TutorialScene(size: self.size)
                tutorialScene.scaleMode = .ResizeFill
                let transitionType = SKTransition.crossFadeWithDuration(1.0)
                view?.presentScene(tutorialScene,transition: transitionType)
            }
           
        }
    }
   

