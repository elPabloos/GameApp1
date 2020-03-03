//
//  GameScene.swift
//  GameApp1
//
//  Created by PaulCiudin on 22/02/2020.
//  Copyright © 2020 PaulCiudin. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let catNode = Cat(imageName: "cat")
    
    var sceneSizeX: CGFloat = 0.0
    var sceneSizeY: CGFloat = 0.0
    var sceneFloor = SKSpriteNode()
    
    let scaleAction = SKAction.scale(by: 0.2, duration: 0.5)
    
    let scoreLabel = SKLabelNode(text: "0")
    var gameDifficulty = 1
    var dropDuration = 7.0
    
    var score: Int = 0 {
        didSet {
            
            if oldValue % (10 * gameDifficulty ) == 0, oldValue != 0 {
                activateNewTimer(timer: &self.timer)
                gameDifficulty *= 7
                dropDuration -= 0.2
            }
            
            if oldValue % (Int.random(in: 7...30)) == 0 && oldValue > 3 {
                AudioPlayerManager.shared.playSound(ofDescription: "burp")
            }
        }
    }
    var timeInterval: Double = 2.0
    var timer = Timer()
    
    override func didMove(to view: SKView) {
        initialiseScene()
        physicsWorld.contactDelegate = self
    
        setTimer(timer: &timer)
    }
    
    private func activateNewTimer(timer: inout Timer) {
        timer.invalidate()
        timeInterval /= 2
        setTimer(timer: &timer)
    }
    
    private func setTimer(timer: inout Timer) {
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (t) in
            self.addMouseNode(imageName: "mouse")
            self.addMouseNode(imageName: "mouse-2")
        })
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let touchLocation = touch?.location(in: self) {
            catNode.position.x = touchLocation.x
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    private func initialiseScene() {
        backgroundColor = SKColor.orange
        sceneSizeX = self.size.width
        sceneSizeY = self.size.height
        
        addScoreLabelNode()
        addSceneFloorNode()
        addCatNode()
        
    }
    
    private func addSceneFloorNode() {
        sceneFloor = SKSpriteNode(color: .black, size: CGSize(width: size.width, height: 5))
        sceneFloor.position = CGPoint.zero
        sceneFloor.anchorPoint = CGPoint.zero
        
        sceneFloor.physicsBody = SKPhysicsBody(rectangleOf: sceneFloor.size)
        sceneFloor.physicsBody?.affectedByGravity = false
        sceneFloor.name = "floor"
        sceneFloor.physicsBody?.contactTestBitMask = 100
        sceneFloor.physicsBody?.categoryBitMask = 10
        
        addChild(sceneFloor)
    }
    
    private func addScoreLabelNode() {
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(scoreLabel)
    }
    
    private func addCatNode() {
        catNode.name = "cat"
        
        catNode.position = CGPoint(x: self.size.width / 2 , y: catNode.size.height / 4 + sceneFloor.size.height )
        catNode.setScale(0.5)
        catNode.zPosition = 1
        
        catNode.physicsBody = SKPhysicsBody(rectangleOf: catNode.size)
        catNode.physicsBody?.affectedByGravity = false
        catNode.physicsBody?.isDynamic = false
        
        catNode.physicsBody?.contactTestBitMask = 123
        
        addChild(catNode)
    }
    
    @objc private func addMouseNode(imageName: String) {
        let mouseNode = SKSpriteNode(imageNamed: imageName)
        mouseNode.name = "mouse"
        
        let mouseX = mouseNode.size.width
        let mouseY = mouseNode.size.height
        
        var scaleRatio: CGFloat = 0
        
        if mouseNode.size.width > 133 || mouseNode.size.height > 136 {
            scaleRatio = (133 / mouseNode.size.width) * 0.5
            mouseNode.physicsBody = SKPhysicsBody(circleOfRadius: mouseY / 2)
        } else {
            scaleRatio = 0.25
            mouseNode.physicsBody = SKPhysicsBody(circleOfRadius: mouseX / 2)
        }
        mouseNode.setScale(scaleRatio)
        
        mouseNode.position.y = sceneSizeY + mouseY/8
        mouseNode.position.x = CGFloat.random(in: (mouseX * scaleRatio )/8...abs(sceneSizeX - (mouseX * scaleRatio )/8) )
//        mouseNode.zRotation = CGFloat(Int.random(in: 0...1) * 90)
        mouseNode.zPosition = 0
        mouseNode.run(SKAction.move(by: CGVector(dx: 1, dy: 1), duration: 1))
        
        mouseNode.physicsBody?.affectedByGravity = false
        mouseNode.physicsBody?.categoryBitMask = 100
        
        addChild(mouseNode)
        
        let dropAction = SKAction.moveTo(y: mouseNode.size.height/4 + 10, duration: dropDuration)
        let deleteAction = SKAction.removeFromParent()
        
        mouseNode.run(SKAction.sequence([dropAction,scaleAction,deleteAction]))
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "mouse" {
            score += 1
            contact.bodyA.isDynamic = false
            nodeA.run(SKAction.sequence([scaleAction, SKAction.removeFromParent()]))
        } else if nodeB.name == "mouse" {
            score += 1
            AudioPlayerManager.shared.setPlayerVolume(ofDescription: "eating", withVolume: 1.5, fadeDuration: 0)
            AudioPlayerManager.shared.playSound(ofDescription: "eating")
            contact.bodyB.isDynamic = false
            nodeB.run(SKAction.sequence([scaleAction, SKAction.removeFromParent()]))
        }
        
        if (nodeA.name == "floor" || nodeB.name == "floor") && score > 10 {
            score -= 10
        }
        
       
        scoreLabel.text = "\(score)"
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let mouse = childNode(withName: "mouse") {
            if mouse.position.y <= 20.0 {
                
            }
        }
    }

}

