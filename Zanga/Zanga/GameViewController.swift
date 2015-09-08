//
//  GameViewController.swift
//  Zanga
//
//  Created by Michelle Goldman on 8/3/15.
//  Copyright (c) 2015 Michelle Goldman. All rights reserved.
//

import AVFoundation
import SpriteKit


//MARK: Background Music
var backgroundMusicPlayer: AVAudioPlayer!

func playBackgroundMusic(filename: String) {
    let url = NSBundle.mainBundle().URLForResource(
        filename, withExtension: nil)
    if (url == nil) {
        println("Could not find file: \"gamemusic")
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

//MARK: Audio Assets
var startgameSound: AVAudioPlayer!
var gameMusic: AVAudioPlayer!
var hubertSound: AVAudioPlayer!
var creatureSound: AVAudioPlayer!
var lostSound: AVAudioPlayer!
var mushroomSound: AVAudioPlayer!


extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Load Audio Assets with Controller
        gameMusic = AVAudioPlayer(contentsOfURL:
            NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(
                "gamemusic", ofType: "mp3")!), error: nil)
        startgameSound = AVAudioPlayer(contentsOfURL:
            NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(
                "startgame", ofType: "wav")!), error: nil)
        hubertSound = AVAudioPlayer(contentsOfURL:
            NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(
                "hubert", ofType: "wav")!), error: nil)
        mushroomSound = AVAudioPlayer(contentsOfURL:
            NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(
                "twinkle", ofType: "wav")!), error: nil)
        lostSound = AVAudioPlayer(contentsOfURL:
            NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(
                "lost", ofType: "wav")!), error: nil)
        creatureSound = AVAudioPlayer(contentsOfURL:
            NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(
                "creature", ofType: "mp3")!), error: nil)
       
        
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            let skView = self.view as! SKView
            scene.size = skView.bounds.size
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.ignoresSiblingOrder = true
            scene.scaleMode = SKSceneScaleMode.ResizeFill
            skView.presentScene(scene)
        }
    }
   
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.LandscapeLeft.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.LandscapeLeft.rawValue)
        }
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
