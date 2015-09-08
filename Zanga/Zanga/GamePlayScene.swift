//
//  GamePlayScene.swift
//  Zanga
//
//  Created by Michelle Goldman on 8/3/15.
//  Updated 8/24/15
//  Copyright (c) 2015 Michelle Goldman. All rights reserved.
//

import AVFoundation
import SpriteKit

//MARK: Physics Category
enum PhysicsCategory : UInt32 {
    case None       = 0
    case All        = 0xFFFFFFFF
    case Hubert     = 0b001
    case Mushroom   = 0b010
    case Creature   = 0b100
}

private let numberOfObstacles = 1
private let numberOfCreatures = 0

var screenSize: CGRect = UIScreen.mainScreen().bounds

class GamePlayScene: SKScene, SKPhysicsContactDelegate {
    
    //MARK: Properties
    
    //Game Hero
    let hubert = SKSpriteNode(imageNamed: "hubert")
    let obstacle3 = SKSpriteNode(imageNamed: "peeps")
    let obstacle5 = SKSpriteNode(imageNamed: "tree_aqua")
    let creature1 = SKSpriteNode(imageNamed: "creature_blue")
    let creature2 = SKSpriteNode(imageNamed: "creature_orange")
    let creature3 = SKSpriteNode(imageNamed: "frog_monster")
    let mushroom1 = SKSpriteNode(imageNamed: "mushroom_hoody")

    //Screen Size, Ambient Color, Back & Foregrounds
    var screenWidth = screenSize.width
    var screenHeight = screenSize.height
    var aspectRatio = screenSize.height / screenSize.width
    
    var scaleFactor: CGFloat! //**
    
    var backgroundNode: SKSpriteNode!
    var backgroundNodeNext: SKSpriteNode!
    var foregroundNode: SKSpriteNode!
    var foregroundNodeNext: SKSpriteNode!
    var backgroundSpeed = 5
    
    //Game Element Properties
    var onGround = true
    var hubertBaseline = CGFloat(0)
    var velocityY = CGFloat(0)
    let gravity = CGFloat(0.6)
    var obstacleMaxX = CGFloat(0)
    var origObstaclePosX = CGFloat(0)
    let orbVelocity: CGFloat = 5.0

    
    //Game State
    private var previousTime: CFTimeInterval = 0.0
    private var lastJumpTime: CFTimeInterval = 1.0
    private var obstaclesHit: Int = numberOfObstacles
    private var trueDeath: Int = numberOfCreatures
    var deltaTime: NSTimeInterval = 0
    var scoreLabel = SKLabelNode()
    var score = 0
    var gamePaused = false
    
    override init(size: CGSize) {
        super.init(size: size)
        scaleFactor = self.size.width / 320.0
        
        createBackground()
        createForeground()
        createHUD()
        createHubert()
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   //MARK: Did Move To View
    override func didMoveToView(view: SKView) {
 
        //Set Physics World
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self

        //Set Creatures

        //Creature 1: Creature - Blue
        self.creature1.name = "obstacleCreatureBlue"
        self.creature1.position = CGPointMake(screenSize.width/2 * 2.5, screenSize.height * 0.23)
        self.creature1.physicsBody = SKPhysicsBody(circleOfRadius: creature1.size.width/3)
        self.creature1.physicsBody?.dynamic = false
        self.creature1.physicsBody?.affectedByGravity = false
        self.creature1.physicsBody?.usesPreciseCollisionDetection = true
        self.creature1.physicsBody?.categoryBitMask = PhysicsCategory.Creature.rawValue
        self.creature1.physicsBody?.collisionBitMask = 0
        self.creature1.physicsBody?.contactTestBitMask = PhysicsCategory.Hubert.rawValue
        self.creature1.setScale(aspectRatio)
        creature1.zPosition = 4

        //Creature 2: Creature - Orange
        self.creature2.name = "obstacleCreatureOrange"
        self.creature2.position = CGPointMake(screenSize.width/2 * 3.2, screenSize.height * 0.23)
        self.creature2.physicsBody = SKPhysicsBody(circleOfRadius: creature2.size.width/3)
        self.creature2.physicsBody?.dynamic = false
        self.creature2.physicsBody?.affectedByGravity = false
        self.creature2.physicsBody?.usesPreciseCollisionDetection = true
        self.creature2.physicsBody?.categoryBitMask = PhysicsCategory.Creature.rawValue
        self.creature2.physicsBody?.collisionBitMask = 0
        self.creature2.physicsBody?.contactTestBitMask = PhysicsCategory.Hubert.rawValue
        self.creature2.setScale(aspectRatio)
        creature2.zPosition = 4

        //Creature 3: Creature - Frog Monster
        self.creature3.name = "obstacleCreatureFrogMonster"
        self.creature3.position = CGPointMake(screenSize.width/2 * 4.5, screenSize.height * 0.23)
        self.creature3.physicsBody = SKPhysicsBody(circleOfRadius: creature3.size.width/3)
        self.creature3.physicsBody?.dynamic = false
        self.creature3.physicsBody?.affectedByGravity = false
        self.creature3.physicsBody?.usesPreciseCollisionDetection = true
        self.creature3.physicsBody?.categoryBitMask = PhysicsCategory.Creature.rawValue
        self.creature3.physicsBody?.collisionBitMask = 0
        self.creature3.physicsBody?.contactTestBitMask = PhysicsCategory.Hubert.rawValue
        self.creature3.setScale(aspectRatio)
        creature3.zPosition = 4
        
        self.origObstaclePosX = self.creature1.position.x
        
        //Instantiate Obstacle Stats Class
        obstacleStatDict["obstacleCreatureBlue"] = ObstacleStats(isLive: false, timeTillNextSpawn: random(), currentInterval: UInt32(0))
        obstacleStatDict["obstacleCreatureOrange"] = ObstacleStats(isLive: false, timeTillNextSpawn: random(), currentInterval: UInt32(0))
        obstacleStatDict["obstacleCreatureFrogMonster"] = ObstacleStats(isLive: false, timeTillNextSpawn: random(), currentInterval: UInt32(0))

        self.obstacleMaxX = 0 - self.creature1.size.width / 2
 
        
        //Add Creature Nodes to Scene
        self.addChild(creature1)
        self.addChild(creature2)
        self.addChild(creature3)

 
        //Initiate Mushroom Spawn
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(spawnMushrooms),
                SKAction.waitForDuration(12.0)
                ])
            ))
 
        //Initiate Green Hill Spawn
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(spawnGreenHills),
                SKAction.waitForDuration(15.0)
                ])
            ))

        //Initiate Gumdrop Tree Spawn
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(spawnGumdropTree),
                SKAction.waitForDuration(26.0)
                ])
            ))
        
        //Initiate Gray Rock Spawn
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(spawnGrayRocks),
                SKAction.waitForDuration(21.0)
                ])
            ))
        
        //Initiate Lt Green Tree
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(spawnGreenTree),
                SKAction.waitForDuration(25.0)
                ])
            ))
        
        //Initiate Blue Rocks
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(spawnBlueRocks),
                SKAction.waitForDuration(19.0)
                ])
            ))


    }
    
    //MARK: Create Background & Foreground//****
    func createBackground() {

        //Background
        backgroundNode = SKSpriteNode(texture: SKTexture(imageNamed: "backgroundImg"))
        backgroundNode!.anchorPoint = CGPoint(x:0, y:0.1)
        backgroundNode!.colorBlendFactor = 0.75
        backgroundNode!.zPosition = 0
        //Background Copy
        backgroundNodeNext = backgroundNode!.copy() as! SKSpriteNode
        backgroundNodeNext!.position = CGPoint(x: backgroundNode!.position.x + backgroundNode!.size.width,
            y: backgroundNode!.position.y)
        backgroundNodeNext!.anchorPoint = CGPoint(x:0, y:0.1)
        
        //Add Background Nodes to Scene
        self.addChild(backgroundNode)
        self.addChild(backgroundNodeNext)
    }
    
    //MARK: Create Foreground //*****
    func createForeground() {

        //Foreground
        foregroundNode = SKSpriteNode(texture: SKTexture(imageNamed: "foregroundImg"))
        foregroundNode!.anchorPoint = CGPoint(x:0, y:0.5)
        foregroundNode!.position = CGPoint(x: CGRectGetMinX(self.frame), y: CGRectGetMinY(self.frame) + (foregroundNode!.size.height/2))
        foregroundNode!.lightingBitMask = 1
        //Foreground Copy
        foregroundNodeNext = foregroundNode!.copy() as! SKSpriteNode
        foregroundNodeNext!.anchorPoint = CGPoint(x:0, y:0.5)
        foregroundNodeNext!.position = CGPoint(x: foregroundNode!.position.x + foregroundNode!.size.width,
            y: foregroundNode!.position.y)
        
        //Add Background & Foreground Nodes to Scene
        self.addChild(foregroundNode)
        self.addChild(foregroundNodeNext)
    }
    
    
    //MARK: Randomness
    //Create Randomness for Creatures
    func random() -> UInt32 {
        var range = UInt32(100)..<UInt32(300)
        return range.startIndex + arc4random_uniform(range.endIndex - range.startIndex + 1)
    }
    

    //MARK: Obstacle Dictionary
    //Keep track of all obstacles
    var obstacleStatDict:Dictionary<String,ObstacleStats>= [:]
    
    
    //MARK: Obstacle Stat Runner
    func obstacleStatRunner() {
        for(obstacle, obstacleStats) in self.obstacleStatDict {
            var thisObstacle = self.childNodeWithName(obstacle)!
            if obstacleStats.runObstacleStats() {
                obstacleStats.timeTillNextSpawn = random()
                obstacleStats.currentInterval = 0
                obstacleStats.isLive = true
            }
            
            if obstacleStats.isLive {
                if thisObstacle.position.x > obstacleMaxX {
                    thisObstacle.position.x -= CGFloat(self.backgroundSpeed)
                }else {
                    thisObstacle.position.x = self.origObstaclePosX
                    obstacleStats.isLive = false
                }
            }else {
                obstacleStats.currentInterval++
            }
        }
    }

    //MARK: Spawn Green Hills
    func spawnGreenHills() {
        let greenHill = SKSpriteNode(imageNamed: "hill_green")

        greenHill.position = CGPointMake(screenSize.width/2 * 4.5, screenSize.height * 0.34)
        //greenHill.position = CGPointMake(CGRectGetMaxX(self.frame) + greenHill.size.width + 80, self.hubertBaseline + 65)
        greenHill.physicsBody?.dynamic = false
        greenHill.physicsBody?.affectedByGravity = false
        greenHill.setScale(aspectRatio)
        greenHill.zPosition = 2
        
        //Move Hills
        let actionMove = SKAction.moveByX(-screenSize.width, y: 0, duration: NSTimeInterval(30))
        let actionMoveDone = SKAction.removeFromParent()
        greenHill.runAction(SKAction.sequence([ actionMove, actionMoveDone]))
        greenHill.runAction(actionMove)
        
        addChild(greenHill)
    }
    
    //MARK: Spawn Gumdrop Tree
    func spawnGumdropTree() {
        let gumdropTree = SKSpriteNode(imageNamed: "tree_gumdrop")
        gumdropTree.position = CGPointMake(screenSize.width/2 * 2.5, screenSize.height * 0.44)
        gumdropTree.physicsBody?.dynamic = false
        gumdropTree.physicsBody?.affectedByGravity = false
        gumdropTree.setScale(aspectRatio)
        gumdropTree.zPosition = 2
        
        //Move Hills
        let actionMove = SKAction.moveByX(-screenSize.width, y: 0, duration: NSTimeInterval(30))
        let actionMoveDone = SKAction.removeFromParent()
        gumdropTree.runAction(SKAction.sequence([ actionMove, actionMoveDone]))
        gumdropTree.runAction(actionMove)
        
        addChild(gumdropTree)
    }
    
    //MARK: Spawn Gray Rocks
    func spawnGrayRocks() {
        let grayRocks = SKSpriteNode(imageNamed: "rocks_gray")
        grayRocks.position = CGPointMake(screenSize.width/2 * 1.5, screenSize.height * 0.42)
        grayRocks.physicsBody?.dynamic = false
        grayRocks.physicsBody?.affectedByGravity = false
        grayRocks.setScale(aspectRatio)
        grayRocks.zPosition = 2
        
        //Move Hills
        let actionMove = SKAction.moveByX(-screenSize.width, y: 0, duration: NSTimeInterval(30))
        let actionMoveDone = SKAction.removeFromParent()
        grayRocks.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        grayRocks.runAction(actionMove)
        
        addChild(grayRocks)
    }
    
    //MARK: Spawn Green Tree
    func spawnGreenTree() {
        let greenTree = SKSpriteNode(imageNamed: "tree_ltgreen")
        greenTree.position = CGPointMake(screenSize.width/2 * 7.5, screenSize.height * 0.42)
        greenTree.physicsBody?.dynamic = false
        greenTree.physicsBody?.affectedByGravity = false
        greenTree.setScale(aspectRatio)
        greenTree.zPosition = 2
        
        //Move Hills
        let actionMove = SKAction.moveByX(-screenSize.width, y: 0, duration: NSTimeInterval(30))
        let actionMoveDone = SKAction.removeFromParent()
        greenTree.runAction(SKAction.sequence([ actionMove, actionMoveDone]))
        greenTree.runAction(actionMove)
        
        addChild(greenTree)
    }
    
    //MARK: Spawn Blue Rocks
    func spawnBlueRocks() {
        let blueRocks = SKSpriteNode(imageNamed: "rocks_blue")
        blueRocks.position = CGPointMake(screenSize.width/2 * 2.5, screenSize.height * 0.37)
        blueRocks.physicsBody?.dynamic = false
        blueRocks.physicsBody?.affectedByGravity = false
        blueRocks.setScale(aspectRatio)
        blueRocks.zPosition = 2
        
        //Move Hills
        let actionMove = SKAction.moveByX(-screenSize.width, y: 0, duration: NSTimeInterval(30))
        let actionMoveDone = SKAction.removeFromParent()
        blueRocks.runAction(SKAction.sequence([ actionMove, actionMoveDone]))
        blueRocks.runAction(actionMove)
        
        addChild(blueRocks)
    }

    
    //MARK: Create Hubert
    func createHubert() {
    
        //self.hubert.position = CGPointMake(screenSize.width * 0.1, screenSize.height * 0.15)
        self.hubert.physicsBody = SKPhysicsBody(circleOfRadius: hubert.size.width/2) 
        self.hubertBaseline = self.foregroundNode!.position.y * aspectRatio + (self.foregroundNode!.size.height/2 - 55)  + (self.hubert.size.height/2) * aspectRatio
        self.hubert.physicsBody?.affectedByGravity = false
        self.hubert.physicsBody?.dynamic = true
        self.hubert.physicsBody?.velocity = CGVector(dx:25, dy:0)
        self.hubert.physicsBody?.allowsRotation = false
        self.hubert.physicsBody?.usesPreciseCollisionDetection = true
        self.hubert.physicsBody?.restitution = 0
        self.hubert.physicsBody?.categoryBitMask = PhysicsCategory.Hubert.rawValue
        self.hubert.physicsBody?.contactTestBitMask = PhysicsCategory.Mushroom.rawValue|PhysicsCategory.Creature.rawValue
        self.hubert.physicsBody?.collisionBitMask = 0
        self.hubert.physicsBody?.usesPreciseCollisionDetection = true
        hubert.name = "hubert"
        hubert.setScale(aspectRatio * 0.75)
        hubert.zPosition = 5
        
        self.addChild(hubert)
    }


    //MARK: Update Hubert
    func updateHubert() {
       
        //Make Hubert jump over obstacles
        self.velocityY += self.gravity
        self.hubert.position.y -= velocityY
        
        if self.hubert.position.y < self.hubertBaseline {
            self.hubert.position.y = self.hubertBaseline
            velocityY = 0.0
            self.onGround = true
        }
    }
    
    //MARK: Spawn Mushrooms
    func spawnMushrooms() {
        //Create Mushrooms
        let mushroom1 = SKSpriteNode(imageNamed: "mushroom_hoody")
        mushroom1.name = "mushroomHoody"
        mushroom1.position = CGPointMake(screenSize.width/2 * 1.7, screenSize.height * 0.15)
        mushroom1.physicsBody = SKPhysicsBody(circleOfRadius: mushroom1.size.width/3)
        mushroom1.physicsBody?.dynamic = false
        mushroom1.physicsBody?.affectedByGravity = false
        mushroom1.physicsBody?.usesPreciseCollisionDetection = true
        mushroom1.physicsBody?.categoryBitMask = PhysicsCategory.Mushroom.rawValue
        mushroom1.physicsBody?.collisionBitMask = 0
        mushroom1.physicsBody?.contactTestBitMask = PhysicsCategory.Hubert.rawValue
        mushroom1.setScale(aspectRatio)
        mushroom1.zPosition = 4
        
        //Move Mushrooms
        let actionMove = SKAction.moveTo(CGPoint(x: mushroom1.size.height, y: screenSize.width/2 ), duration: NSTimeInterval(15))
        let actionMoveDone = SKAction.removeFromParent()
        mushroom1.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        mushroom1.runAction(actionMove)

        addChild(mushroom1)
    }
    
    //MARK: Hubert Collides with Mushroom
    func hubertHitsMushroom(mushroom1:SKSpriteNode, hubert:SKSpriteNode) {
        mushroomSound.play()
        mushroomContact(self.mushroom1.position)
        score = score + 25
        hubert.removeFromParent()
    }
    
    //MARK: Magic Emitter (Used with Mushroom Contact)
    func mushroomContact(CGPoint){
        var emitterNode = SKEmitterNode(fileNamed: "MagicParticle.sks")
        emitterNode.particlePosition = CGPointMake(screenSize.width/2, screenSize.height * 0.23)
        
        self.addChild(emitterNode)
        //Remove emitter node after explosion
        self.runAction(SKAction.waitForDuration(1/2), completion: {
            emitterNode.removeFromParent()
        })
    }
    
    
    //MARK: Hubert Dies
    func hubertDies() {
        lostSound.play()
    }
    
    //MARK: Hubert Collides with Creature
    func hubertHitsCreature() {
        creatureSound.play()
        trueDeath++
        hubertDies()
    }
 
    
    //MARK: Did Begin Contact
    func didBeginContact(contact: SKPhysicsContact) {

        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
 
        if (firstBody.categoryBitMask == PhysicsCategory.Hubert.rawValue &&
            secondBody.categoryBitMask == PhysicsCategory.Mushroom.rawValue) {
                hubertHitsMushroom(firstBody.node as! SKSpriteNode, hubert: secondBody.node as! SKSpriteNode)
        } else if (firstBody.categoryBitMask == PhysicsCategory.Hubert.rawValue &&
            secondBody.categoryBitMask == PhysicsCategory.Creature.rawValue) {
                hubertHitsCreature()
        }

        //MARK: Game Over
        func gameOver() {
            let gameOverScene = GameOverScene(size: self.size,
                won: score > 150 && trueDeath == 0 ? true : false)
            gameOverScene.scaleMode = .ResizeFill
            self.view?.presentScene(gameOverScene, transition: SKTransition.crossFadeWithDuration(1.0))
            lostSound.play()
            
            //Reset score
            self.score=0
            self.scoreLabel.text = String(0)
            self.gamePaused = false
        }
        
        //Check if Game is Over
        if  trueDeath == 1 {
            gameOver()
        }
       
    }
    
    //MARK: Create HUD with Pause Button & Score
    func createHUD() {
        //Create root node with clear background to group score and pause button
        var hud = SKSpriteNode(color: UIColor.clearColor(), size: CGSizeMake(self.size.width, self.size.height*0.10))
        hud.anchorPoint = CGPointMake(0, 0)
        hud.position = CGPointMake(0, self.size.height - hud.size.height)
        
        self.addChild(hud)
        
        //Create pause button container & label
        var pauseContainer = SKSpriteNode()
        pauseContainer.position = CGPointMake(hud.size.width/2, 1)
        pauseContainer.size = CGSizeMake(hud.size.height*3, hud.size.height*2)
        pauseContainer.name = "PauseButtonContainer"
        hud.addChild(pauseContainer)
        
        var pauseButton = SKLabelNode()
        pauseButton.position = CGPointMake(hud.size.width/2, 3)
        pauseButton.text="I I"
        pauseButton.fontName = "Futura"
        pauseButton.fontSize=hud.size.height
        pauseButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        pauseButton.name="pausegame"
        hud.addChild(pauseButton)
        
        //Display the current score
        self.score = 0
        self.scoreLabel.position = CGPointMake(hud.size.width-hud.size.width * 0.2, 2)
        self.scoreLabel.text = "0"
        self.scoreLabel.fontName = "Futura"
        self.scoreLabel.color = UIColor.whiteColor()
        self.scoreLabel.fontSize = hud.size.height
        
        hud.addChild(self.scoreLabel)
    }
    
    //MARK: Game Pause
    func showPauseAlert() {
        self.gamePaused = true
        self.scene?.view?.paused = true
        
        //Stop background music
        backgroundMusicPlayer.pause()
        
        var alert = UIAlertController(title: "Game Paused", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Continue Playing", style: UIAlertActionStyle.Default)  { _ in
            self.gamePaused = false
            self.scene?.view?.paused = false
            backgroundMusicPlayer.play()
            
            })
        self.view?.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: Touches Began
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
      
        //Detect Pause Button
        for touch: AnyObject in touches {
            var location = touch.locationInNode(self)
            var node = self.nodeAtPoint(location)
            if (node.name == "pausegame") || (node.name == "PauseButtonContainer") {
                showPauseAlert()
            } else {
                
                //Detect if Hubert is on the Ground
                if self.onGround {
                    self.velocityY = -18.0
                    self.onGround = false
                }
                //Play sound effect when Hubert is tapped
                hubertSound.play()
            }
        }
    }

    
    //MARK: Touches Ended
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if self.velocityY < -9.0 {
            self.velocityY = -9.0
        }
    }
    

    //MARK: Update
    override func update(currentTime: NSTimeInterval) {
        
        if previousTime <= 0 {
            previousTime = currentTime
        }
        
        deltaTime = currentTime - previousTime
        previousTime = currentTime
 
        //Increase score
        if currentTime - lastJumpTime >= 1 {
            lastJumpTime=currentTime
            
            self.scoreLabel.text = String(score)
        }

        //Move Background and Foreground

        var y:CGFloat = screenHeight/10.0
        
        var backgroundOffset: CGFloat = -CGFloat(Int(currentTime*100) % (1920*2)); //orig currentTime*100
        backgroundNode!.position = CGPoint(x:((backgroundOffset < -1920) ? (3840+backgroundOffset) : backgroundOffset), y:y)
        backgroundNodeNext!.position = CGPoint(x:(1920+backgroundOffset), y:y)
        
        var foregroundOffset: CGFloat = -CGFloat(Int(currentTime*200) % (1920*2));//orig currentTime*250
        foregroundNode!.position = CGPoint(x:((foregroundOffset < -1920) ? (3840+foregroundOffset) : foregroundOffset), y:y)
        foregroundNodeNext!.position = CGPoint(x:(1920+foregroundOffset), y:y)

        updateHubert()
        obstacleStatRunner()

    }
}


