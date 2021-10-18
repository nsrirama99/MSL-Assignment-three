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
        
        left.size = CGSize(width: size.width * 0.01, height: size.height * 0.8)
        left.position = CGPoint(x:0, y:size.height*0.6)
        
        right.size = CGSize(width: size.width * 0.01, height: size.height * 0.8)
        right.position = CGPoint(x:size.width, y:size.height*0.6)
        
        top.size = CGSize(width: size.width, height: size.height * 0.01)
        top.position = CGPoint(x:0, y:size.height)
        
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
        let ball = SKSpriteNode(imageNamed: "ball.png")
        
        ball.size = CGSize(width:size.width * 0.04, height:size.width * 0.04)
        
        let randNumber = CGFloat(Float.random(in: 0.1...0.9))
        ball.position = CGPoint(x: size.width * randNumber, y: size.height * 0.5)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: size.width * 0.02)
        ball.physicsBody?.restitution = 1.1
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.contactTestBitMask = 0x00000001
        ball.physicsBody?.collisionBitMask = 0x00000001
        ball.physicsBody?.categoryBitMask = 0x00000001
        
        self.addChild(ball)
    }
    
    func addPaddle(){
        let paddle = SKSpriteNode()
        paddle.size = CGSize(width:size.width * 0.2, height:size.width * 0.01)
        paddle.position = CGPoint(x: size.width * 0.5, y: size.height * 0.2)
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = true
        paddle.physicsBody?.allowsRotation = false
        self.addChild(paddle)
    }
    
    func addScore(){
        let scoreLabel = SKLabelNode()
        scoreLabel.text = "0"
        scoreLabel.fontSize = 16
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.minY)
        addChild(scoreLabel)
    }
}
