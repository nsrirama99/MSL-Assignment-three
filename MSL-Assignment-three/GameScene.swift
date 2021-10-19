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
    var paddlePos = 0.0
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
        self.paddlePos = self.motion.deviceMotion?.attitude.roll ?? 0.0 - referenceRoll
    }
    
    func addWalls(){
        let left = SKSpriteNode()
        let right = SKSpriteNode()
        let top = SKSpriteNode()
        
        left.size = CGSize(width: 10, height: size.height * 0.7)
        left.position = CGPoint(x:0, y:size.height*0.5)
        
        right.size = CGSize(width: 10, height: size.height * 0.7)
        right.position = CGPoint(x:size.width, y:size.height*0.5)
        
        top.size = CGSize(width: size.width * 2, height: 10)
        top.position = CGPoint(x:0, y:size.height * 0.85)
        
        for obj in [left, right, top]{
            obj.color = UIColor.black
            obj.physicsBody = SKPhysicsBody(rectangleOf: obj.size)
            obj.physicsBody?.isDynamic = true
            obj.physicsBody?.pinned = true
            obj.physicsBody?.allowsRotation = false
            self.addChild(obj)
        }
    }
    
    func addBall(){
        let ball = SKShapeNode(circleOfRadius: 10)
        ball.fillColor = UIColor.black
        
        let randNumber = CGFloat(Float.random(in: 0.1...0.9))
        ball.position = CGPoint(x: size.width * randNumber, y: size.height * 0.5)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: size.width * 0.03)
        ball.physicsBody?.restitution = 1.1
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.contactTestBitMask = 0x00000001
        ball.physicsBody?.collisionBitMask = 0x00000001
        ball.physicsBody?.categoryBitMask = 0x00000001
        
        self.addChild(ball)
        
        var impulseX = Bool.random() ? -1 : 1
        ball.physicsBody?.applyImpulse(CGVector(dx: 10 * impulseX, dy: 10))
    }
    
    func addPaddle(){
        let paddle = SKSpriteNode()
        paddle.size = CGSize(width: 100 + extraSteps, height: 10)
        paddle.position = CGPoint(x: size.width * 0.5, y: size.height * 0.15)
        paddle.color = UIColor.gray
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = true
        paddle.physicsBody?.allowsRotation = false
        paddle.physicsBody?.affectedByGravity = false
        self.addChild(paddle)
    }
    
    func addScore(){
        let scoreLabel = SKLabelNode()
        scoreLabel.text = "0"
        scoreLabel.fontSize = 16
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.minY)
        addChild(scoreLabel)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // If the ball interacts with top wall, then increment
        if contact.bodyA.node == spinBlock || contact.bodyB.node == spinBlock {
            self.score += 1
        }
    }
}
