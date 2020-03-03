//
//  StartScene.swift
//  GameApp1
//
//  Created by PaulCiudin on 22/02/2020.
//  Copyright © 2020 PaulCiudin. All rights reserved.
//

import SpriteKit

class StartScene: SKScene {
    
    let startButton = SKSpriteNode(imageNamed: "start")
    var catsTexture = [SKTexture()]
    let catNode = SKSpriteNode(imageNamed: "cat-1")
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        
        addStartButton()
        addCatAnimation()
        
        AudioPlayerManager.shared.playSound(ofDescription: "music")
    }
    
    private func addStartButton() {
        
        startButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 4)
        startButton.setScale(0.5)
        addChild(startButton)
    }
    
    private func addCatAnimation() {
       
        
        catNode.position = CGPoint(x: self.size.width/2, y: self.size.height * 3/4)
        catNode.setScale(0.8)
        
        for i in 1...12 {
            catsTexture.append(SKTexture(imageNamed: "\(i)"))
        }
        
        let dinglyAction = SKAction.animate(with: catsTexture, timePerFrame: 0.09)
        catNode.run(SKAction.repeatForever(dinglyAction))
        
        addChild(catNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let firstTouch = touches.first
        guard let touchLocation = firstTouch?.location(in: self) else { return }
        
        if atPoint(touchLocation) == startButton {
            let gameScene = GameScene(size: self.size)
            let trans = SKTransition.crossFade(withDuration: 1)
            view?.presentScene(gameScene, transition: trans)
            AudioPlayerManager.shared.setPlayerVolume(ofDescription: "music", withVolume: 0.2, fadeDuration: 0.5)
        }
        
        
    }
}
