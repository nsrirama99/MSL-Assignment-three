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
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = SKColor.white
        
        self.startMotionUpdates()
        self.addWalls()
        self.addBall()
        self.addPaddle()
        self.addBoundary()
        self.addScore()
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
        
        let impulseX = Bool.random() ? -1 : 1
        
        ball.physicsBody?.applyImpulse(CGVector(dx: 5 * impulseX, dy: 5))
    }
    
    func addPaddle(){
        let paddle = SKSpriteNode()
        paddle.name = "paddle"
        paddle.size = CGSize(width: 100 + extraSteps, height: 10)
        paddle.position = CGPoint(x: size.width * 0.5, y: size.height * 0.15)
        paddle.color = UIColor.gray
        paddle.physicsBody?.restitution = 1.0
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        paddle.physicsBody?.allowsRotation = false
        paddle.physicsBody?.affectedByGravity = false
        paddle.physicsBody?.contactTestBitMask = 0x00000001
        paddle.physicsBody?.collisionBitMask = 0x00000001
        paddle.physicsBody?.categoryBitMask = 0x00000001
        paddle.physicsBody?.linearDamping = 0
        paddle.physicsBody?.friction = 0
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        // If the ball interacts with top wall, then increment
        if contact.bodyA.node == childNode(withName: "top") || contact.bodyB.node == childNode(withName: "top") {
            self.score += 1
        }
        if contact.bodyA.node == childNode(withName: "boundary") || contact.bodyB.node == childNode(withName: "boundary") {
            childNode(withName: "ball")?.removeFromParent();
        }
    }
}
