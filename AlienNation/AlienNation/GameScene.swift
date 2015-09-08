//
//  GameScene.swift
//  AlienNation
//
//  Created by Michelle Goldman on 6/3/15.
//  Copyright (c) 2015 Michelle Goldman. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation


//SET UP PHYSICS CATEGORIES//
struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Alien     : UInt32 = 0b10
    static let Bullet    : UInt32 = 0b11
}


//LOAD SOUND EFFECT FILES//
let dyingAlienSound = SKAction.playSoundFileNamed("dyingalien", waitForCompletion: false)
let tapAlienSound = SKAction.playSoundFileNamed("blip", waitForCompletion: false)


//SET SHOOTING CALCULATIONS//
func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

//CREATE SPACESHIP TEXTURE
var spaceship : SKSpriteNode!
var spaceshipMovement : [SKTexture]!


//GAME SCENE
class GameScene: SKScene, SKPhysicsContactDelegate {
   
    
    //GAME GLOBAL PROPERTIES
    var alien = SKSpriteNode()
    var background = SKSpriteNode()
    var cloud1Node = SKSpriteNode()
    var cloud1NodeNext = SKSpriteNode()
    var cloud2Node = SKSpriteNode()
    var cloud2NodeNext = SKSpriteNode()
    var raygun = SKSpriteNode()
    var bullet = SKSpriteNode()
    
    var lastUpdateTimeInterval : CFTimeInterval = 0
    var lastFrameTime : CFTimeInterval = 0
    var deltaTime : CFTimeInterval = 0
    var timePerMove: CFTimeInterval = 0.35
    var sprite: SKSpriteNode!
    var xVelocity: CGFloat = 0
    
    //HUD GLOBAL PROPERTIES//
    let timeNode = SKLabelNode(text: "45")
    var timer : NSTimer?
    var count = 45
    var scoreNode = SKLabelNode()
    var score = 0
    var lastShootTime: CFTimeInterval = 1
    var gamePaused = false
    
    //SET BACKGROUND & CREATE CLOUD SPRITES TO USE WITH INTERPOLATION
    override init(size: CGSize) {
        super.init(size: size)
                
        //SET BACKGROUND//
        let background = SKSpriteNode(imageNamed: "background")
        //background = SKSpriteNode(texture: backgroundTexture)
        background.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        //stretch out background to match device height
        background.size.height = self.frame.height
        
        self.addChild(background)
        
        //Prepare cloud 1 sprite
        cloud1Node = SKSpriteNode(texture: SKTexture(imageNamed: "cloud1"))
        cloud1Node.position = CGPoint(x: 200, y: 505)
        
        cloud1NodeNext = cloud1Node.copy() as! SKSpriteNode
        cloud1NodeNext.position = CGPoint(x: cloud1Node.position.x + cloud1Node.size.width, y: cloud1Node.position.y)
        
        //Prepare cloud 2 sprite
        cloud2Node = SKSpriteNode(texture: SKTexture(imageNamed: "cloud2"))
        cloud2Node.position = CGPoint(x: 800, y: 570)
        
        cloud2NodeNext = cloud2Node.copy() as! SKSpriteNode
        cloud2NodeNext.position = CGPoint(x: cloud2Node.position.x + cloud2Node.size.width, y: cloud2Node.position.y)
        
        //Add sprites to scene
        self.addChild(cloud1Node)
        self.addChild(cloud1NodeNext)
        self.addChild(cloud2Node)
        self.addChild(cloud2NodeNext)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    //DID MOVE TO VIEW
    override func didMoveToView(view: SKView) {
        
        //RAYGUN SPRITE//
        var raygunTexture = SKTexture(imageNamed: "aliengun")
        raygun = SKSpriteNode(texture: raygunTexture)
        raygun.position = CGPoint(x: 20, y: 70)
        
        raygun.zPosition = 7
        
        self.addChild(raygun)
        
        //HANDLE COLLISIONS//
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        //INITIATE ALIEN MOVEMENT//
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addAlien),
                SKAction.waitForDuration(1.0)
            ])
        ))
      
        //ADD HUD//
        createHUD()
        
        //SET UP SPACESHIP TEXTURE ATLAS FOR ANIMATION//
        let spaceshipAnimatedAtlas = SKTextureAtlas(named: "SpaceshipImages")
        var moveFrames = [SKTexture]()
        
        let numImages = spaceshipAnimatedAtlas.textureNames.count
        for var i=1; i<=numImages/2; i++ {
            let spaceshipTextureName = "alienspaceship\(i)"
            moveFrames.append(spaceshipAnimatedAtlas.textureNamed(spaceshipTextureName))
        }
        spaceshipMovement = moveFrames
        
        let firstFrame = spaceshipMovement[0]
        spaceship = SKSpriteNode(texture: firstFrame)
        spaceship.position = CGPoint(x: 300, y: 480)
        addChild(spaceship)
        
        movingSpaceship()
    }
    
    //ANIMATE SPACESHIP LIGHTS//
    func movingSpaceship() {
        spaceship.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(spaceshipMovement, timePerFrame: 0.3, resize: true, restore: true)), withKey:"movingLightsOnSpaceship")
    }

    //SET RANDOM MOVEMENT OF ALIENS//
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }

    //ADD ALIEN SPRITES//
    func addAlien() {
        
        // Create alien
        let alien = SKSpriteNode(imageNamed: "alien")
        
        // Determine where to spawn alien along Y axis
        let actualY = random(min: -alien.size.height/2, max: size.height - alien.size.height/2)
        let actualX = random(min: -alien.size.height/2, max: size.height - alien.size.height/2)
        
        // Position alien slightly off-screen along the right edge,
        // along a random position along the Y axis as calculated above
        alien.position = CGPoint(x: size.width + alien.size.width/2, y: actualY)
        
        // Add alien to the scene
        addChild(alien)
        
        //Create alien physics
        alien.physicsBody = SKPhysicsBody(rectangleOfSize: alien.size)
        alien.physicsBody?.dynamic = true
        alien.physicsBody?.affectedByGravity = true
        alien.physicsBody?.categoryBitMask = PhysicsCategory.Alien
        alien.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet
        alien.physicsBody?.collisionBitMask = PhysicsCategory.None
        // Determine alien speed
        let actualDuration = random(min: CGFloat(5.0), max: CGFloat(5.0))
        
        // Create alien actions
        let actionMove = SKAction.moveTo(CGPoint(x: alien.size.width*3, y: alien.size.width*2), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        alien.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
    }

    //FIREFLY EXPLOSION WHEN ALIEN IS KILLED//
    func explosion(CGPoint){
        var emitterNode = SKEmitterNode(fileNamed: "FirefliesParticle.sks")
        emitterNode.particlePosition = self.alien.position
        self.addChild(emitterNode)
        //Remove emitter node after explosion
        self.runAction(SKAction.waitForDuration(1/2), completion: {
            emitterNode.removeFromParent()
        })
    }

    //TOUCHES BEGAN//
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        //Detect pause button
        for touch: AnyObject in touches {
            var location = touch.locationInNode(self)
            var node = self.nodeAtPoint(location)
            if (node.name == "pausegame") || (node.name == "PauseButtonContainer") {
                showPauseAlert()
            } else {
                //...
            }
        }
        
    }
    
    //CREATE GAME PAUSE ALERT//
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
    
    //TOUCHES ENDED//
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        //Play sound effect when alien is killed
        runAction(SKAction.playSoundFileNamed("raygun.wav", waitForCompletion: false))
        
        //Choose one of the touches to work with
        let touch = touches.first as? UITouch
        let touchLocation = touch!.locationInNode(self)
        
        //Set up initial location of projectile
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.position = raygun.position
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        bullet.physicsBody?.dynamic = true
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Alien
        bullet.physicsBody?.collisionBitMask = PhysicsCategory.None
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        //Determine offset of location to projectile
        let offset = touchLocation - bullet.position
        
        //Bail out if you are shooting down or backwards
        if (offset.x < 0) { return }
        
        //OK to add now - you've double checked position
        addChild(bullet)
        
        //Get the direction of where to shoot
        let direction = offset.normalized()
        
        //Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        //Add the shoot amount to the current position
        let realDest = shootAmount + bullet.position
        
        //Create the actions
        let actionMove = SKAction.moveTo(realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        bullet.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    

    //HANDLE ALIEN COLLISION//
    func bulletCollidesWithAlien(bullet:SKSpriteNode, alien:SKSpriteNode) {
       runAction(SKAction.playSoundFileNamed("aliendeath.wav", waitForCompletion: false))
        score = score + 5
        explosion(self.alien.position)
        bullet.removeFromParent()
        alien.removeFromParent()
    }

    //HANDLE PHYSICS CONTACT, OUT OF TIME, GAME OVER & HUD RESTORATION//
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
        
        
        if (firstBody.categoryBitMask == PhysicsCategory.Alien &&
            secondBody.categoryBitMask == PhysicsCategory.Bullet) {
                bulletCollidesWithAlien(firstBody.node as! SKSpriteNode, alien: secondBody.node as! SKSpriteNode)
        }
    

        //Load game over scene
        func showGameOverAlert() {
            self.gamePaused = true
            let gameOverScene = GameOverScene(size: size)
            gameOverScene.scaleMode = scaleMode
            let transitionType = SKTransition.crossFadeWithDuration(2.0)
            view?.presentScene(gameOverScene,transition: transitionType)

            // reset score
            self.score=0
            self.scoreNode.text = String(0)
            self.gamePaused = false
        }
    
     
        //Check score
        if (self.score==200) {
            showGameOverAlert()
            
        }

    }
    
    //CREATE HUD//
    func createHUD() {
        //Create root node with black background to position and group HUD elements
        //Size relative to device screen resolution
        
        var hud = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(self.size.width, self.size.height*0.05))
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
        pauseButton.position = CGPointMake(hud.size.width/2, 1)
        pauseButton.text="I I"
        pauseButton.fontName = "Futura"
        pauseButton.fontSize=hud.size.height
        pauseButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        pauseButton.name="pausegame"
        hud.addChild(pauseButton)
        
        //Display the current score
        self.score = 0
        self.scoreNode.position = CGPointMake(hud.size.width-hud.size.width * 0.2, 2)
        self.scoreNode.text = "0"
        self.scoreNode.fontName = "Futura"
        self.scoreNode.color = UIColor.purpleColor()
        self.scoreNode.fontSize = hud.size.height
        hud.addChild(self.scoreNode)
    }
    
    //MOVE CLOUD SPRITES USING INTERPOLATION/DELTA TIME
    func moveSprite(sprite : SKSpriteNode, nextSprite : SKSpriteNode, speed : Float) -> Void {
        var newPosition = CGPointZero
        
        //For the sprite and its duplicate
        for spriteToMove in [sprite, nextSprite] {
            newPosition = spriteToMove.position
            newPosition.x -= CGFloat(speed * Float(deltaTime))
            spriteToMove.position = newPosition
            
            //If sprite is now off screen(farther than screen's left most edge)
            if spriteToMove.frame.maxX < self.frame.minX {
                //Shift sprite over so it's now to the immediate right of the other sprite
                spriteToMove.position = CGPoint(x: spriteToMove.position.x + spriteToMove.size.width * 2, y: spriteToMove.position.y)
            }
        }
    }
   
    //CREATE SCORING MECHANISM//
    override func update(currentTime: CFTimeInterval) {
 
        if (currentTime - lastFrameTime < timePerMove){
            return
        }
        //If there is no last time frame value, this is the first frame making delta zero
        if lastFrameTime == 0 {
            lastFrameTime = currentTime
        }
        //Update delta time
        deltaTime = currentTime - lastFrameTime
        //Set last frame time to current time
        lastFrameTime = currentTime
        
        //Move sprites
        self.moveSprite(cloud1Node, nextSprite:cloud1NodeNext, speed:20.0)
        self.moveSprite(cloud2Node, nextSprite: cloud2NodeNext, speed: 10.0)

        self.lastFrameTime = currentTime
        
        //Increase score
        if currentTime - lastShootTime >= 1 {
            lastShootTime=currentTime
       
            self.scoreNode.text = String(score)
        }

    }
    
   
}
