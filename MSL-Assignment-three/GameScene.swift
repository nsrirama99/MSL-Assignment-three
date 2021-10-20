//
//  GameScene.swift
//  MSL-Assignment-three
//
//  Created by Anna Iorio on 10/18/21.
//

import UIKit
import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let motion = CMMotionManager()
    var extraSteps = 0
    
    var referenceRoll = 0.0
    
    let scoreLabel = SKLabelNode()
    var score:Int = 0 {
        willSet(newValue){
            DispatchQueue.main.async {
                self.scoreLabel.text = "\(newValue)"
            }
        }
    }
    
    var paddleWidth = 100
    let paddle = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = SKColor.white
        
        self.startMotionUpdates()
        self.addStart()
        self.addWalls()
        self.addBall()
        self.addPaddle(self.paddleWidth)
        self.addBoundary()
        self.addScore()
        self.addWidener()
        self.score = 0
    }
    
    func startMotionUpdates(){
        if self.motion.isDeviceMotionAvailable{
            self.motion.accelerometerUpdateInterval = 0.1
            self.motion.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: self.handleMotion)
            self.referenceRoll = self.motion.deviceMotion?.attitude.roll ?? 0.0;
        }
    }
    
    func handleMotion(_ motionData:CMDeviceMotion?, error:Error?){
        if (self.referenceRoll == 0.0){
            self.referenceRoll = motionData?.attitude.roll ?? 0.0
        }
        let paddlePos = motionData?.attitude.roll ?? 0.0 - referenceRoll
        childNode(withName: "paddle")?.position = CGPoint(x: size.width * 0.5 + paddlePos * 200, y: size.height * 0.15)   
    }
    
    func addStart(){
        let start = SKLabelNode()
        start.name = "start"
        start.text = "START"
        start.fontSize = 48
        start.fontColor = SKColor.black
        start.position = CGPoint(x: frame.midX, y: size.height * 0.5)
        addChild(start)
    }
    
    func addWalls(){
        let left = SKSpriteNode()
        let right = SKSpriteNode()
        let top = SKSpriteNode()
        top.name = "top"
        
        left.size = CGSize(width: 10, height: size.height * 0.7)
        left.position = CGPoint(x:0, y:size.height*0.5)
        
        right.size = CGSize(width: 10, height: size.height * 0.7)
        right.position = CGPoint(x:size.width, y:size.height*0.5)
        
        top.size = CGSize(width: size.width, height: 10)
        top.position = CGPoint(x: size.width * 0.5, y:size.height * 0.85)
        
        for obj in [left, right, top]{
            obj.color = UIColor.black
            obj.physicsBody = SKPhysicsBody(rectangleOf: obj.size)
            obj.physicsBody?.isDynamic = false
            obj.physicsBody?.pinned = true
            obj.physicsBody?.allowsRotation = false
            self.addChild(obj)
        }
    }
    
    func addBall(){
        let ball = SKShapeNode(circleOfRadius: 10)
        ball.fillColor = UIColor.black
        ball.name = "ball"
        
        let randNumber = CGFloat(Float.random(in: 0.1...0.9))
        ball.position = CGPoint(x: size.width * randNumber, y: size.height * 0.2)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: size.width * 0.03)
        ball.physicsBody?.restitution = 1.0
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.contactTestBitMask = 0x00000001
        ball.physicsBody?.collisionBitMask = 0x00000001
        ball.physicsBody?.categoryBitMask = 0x00000001
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.friction = 0
        
        self.addChild(ball)
    }
    
    func addPaddle(paddleWidth: Int){
        self.paddle.name = "paddle"
        self.paddle.size = CGSize(width: paddleWidth, height: 10)
        self.paddle.position = CGPoint(x: size.width * 0.5, y: size.height * 0.15)
        self.paddle.color = UIColor.gray
        self.paddle.physicsBody?.restitution = 1.0
        self.paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        self.paddle.physicsBody?.isDynamic = false
        self.paddle.physicsBody?.allowsRotation = false
        self.paddle.physicsBody?.affectedByGravity = false
        self.paddle.physicsBody?.contactTestBitMask = 0x00000001
        self.paddle.physicsBody?.collisionBitMask = 0x00000001
        self.paddle.physicsBody?.categoryBitMask = 0x00000001
        self.paddle.physicsBody?.linearDamping = 0
        self.paddle.physicsBody?.friction = 0
        self.addChild(paddle)
    }
    
    func addBoundary(){
        let boundary = SKSpriteNode();
        boundary.name = "boundary"
        boundary.size = CGSize(width: size.width * 2, height: 20)
        boundary.position = CGPoint(x: size.width * 0.5, y: 0)
        boundary.color = UIColor.white
        boundary.physicsBody = SKPhysicsBody(rectangleOf: boundary.size)
        boundary.physicsBody?.isDynamic = false
        boundary.physicsBody?.pinned = true
        boundary.physicsBody?.allowsRotation = false
        self.addChild(boundary)
    }
    
    func addScore(){
        self.scoreLabel.text = "0"
        self.scoreLabel.fontSize = 32
        self.scoreLabel.fontColor = SKColor.black
        self.scoreLabel.position = CGPoint(x: frame.midX, y: frame.minY + 30)
        addChild(self.scoreLabel)
    }
    
    func addWidener(){
        let increment = SKLabelNode();
        let decrement = SKLabelNode();
        increment.name = "widen"
        decrement.name = "narrow"
        increment.text = "+"
        decrement.text = "-"
        increment.fontSize = 32
        decrement.fontSize = 32
        increment.fontColor = SKColor.black
        decrement.fontColor = SKColor.black
        increment.position = CGPoint(x: frame.maxX - 20, y: frame.minY + 30)
        decrement.position = CGPoint(x: frame.minX + 20, y: frame.minY + 30)
        self.addChild(increment)
        self.addChild(decrement)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // If the ball interacts with top wall, then increment
        if contact.bodyA.node == childNode(withName: "top") || contact.bodyB.node == childNode(withName: "top") {
            self.score += 1
        }
        if contact.bodyA.node == childNode(withName: "boundary") || contact.bodyB.node == childNode(withName: "boundary") {
            childNode(withName: "ball")?.removeFromParent();
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "widen" {
                if (self.extraSteps > 10){
                    self.paddleWidth += 10
                    self.extraSteps -= 10
                    childNode(withName: "paddle")?.removeFromParent()
                    addPaddle(self.paddleWidth)
                }
            }
            else if touchedNode.name == "narrow" {
                if (self.paddle.size.width > 30){
                    self.paddleWidth -= 10
                    self.extraSteps += 10
                    childNode(withName: "paddle")?.removeFromParent()
                    addPaddle(self.paddleWidth)
                }
            }
            else if touchedNode.name == "start" {
                childNode(withName: "increment")?.removeFromParent()
                childNode(withName: "decrement")?.removeFromParent()
                childNode(withName: "start")?.removeFromParent()
                let impulseX = Bool.random() ? -1 : 1
                childNode(withName:"ball")?.physicsBody?.applyImpulse(CGVector(dx: 5 * impulseX, dy: 5))
            }
        }
    }
}
