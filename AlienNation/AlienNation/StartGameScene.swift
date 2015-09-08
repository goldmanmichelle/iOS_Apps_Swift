//
//  StartGameScene.swift
//  AlienNation
//
//  Created by Michelle Goldman on 6/8/15.
//  Copyright (c) 2015 Michelle Goldman. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

//SET UP GAME AUDIO//
var backgroundMusicPlayer: AVAudioPlayer!

func playBackgroundMusic(filename: String) {
    let url = NSBundle.mainBundle().URLForResource(
        filename, withExtension: nil)
    if (url == nil) {
        println("Could not find file: \"backgroundmusic")
        return
    }
    
    var error: NSError? = nil
    backgroundMusicPlayer =
        AVAudioPlayer(contentsOfURL: url, error: &error)
    if backgroundMusicPlayer == nil {
        println("Could not create audio player: \(error!)")
        return
    }
    
    backgroundMusicPlayer.numberOfLoops = -1
    backgroundMusicPlayer.volume = 0.4
    backgroundMusicPlayer.prepareToPlay()
    backgroundMusicPlayer.play()
}

//LOAD SOUND EFFECT FILES//
let startgameSound = SKAction.playSoundFileNamed("startgame", waitForCompletion: false)

class StartGameScene: SKScene {
   
    override func didMoveToView(view: SKView) {
        //SET GAME BACKGROUND MUSIC & SOUND EFFECTS//
        playBackgroundMusic("backgroundmusic.mp3")
        
        //SET BACKGROUND//
        let background = SKSpriteNode(imageNamed: "startscreen")
        //background = SKSpriteNode(texture: backgroundTexture)
        background.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        //stretch out background to match device height
        background.size.height = self.frame.height
        
        self.addChild(background)
        
      
        //CREATE START GAME BUTTON//
        let startGameButton = SKSpriteNode(imageNamed: "startgamebtn")
        startGameButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-75)
        startGameButton.name = "startgame"
        addChild(startGameButton)
        
        //CREATE CREDITS BUTTON//
        let gameCreditsButton = SKSpriteNode(imageNamed: "creditsbtn")
        gameCreditsButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-175)
        gameCreditsButton.name = "gamecredits"
        addChild(gameCreditsButton)
        
        //CREATE HELP BUTTON//
        let helpButton = SKSpriteNode(imageNamed: "help")
        helpButton.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-250)
        helpButton.name = "help"
        addChild(helpButton)
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
        } else if(touchedNode.name == "gamecredits"){
            let creditsScene = GameCreditsScene(size: size)
            creditsScene.scaleMode = scaleMode
            let transitionType = SKTransition.crossFadeWithDuration(2.0)
            view?.presentScene(creditsScene,transition: transitionType)
        } else if(touchedNode.name == "help"){
            let helpScene = TutorialScene(size: size)
            helpScene.scaleMode = scaleMode
            let transitionType = SKTransition.crossFadeWithDuration(2.0)
            view?.presentScene(helpScene,transition: transitionType)
        }
    }
    
}
