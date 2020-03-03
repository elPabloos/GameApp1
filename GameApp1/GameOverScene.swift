//
//  GameOverScene.swift
//  GameApp
//
//  Created by deeodus on 05/06/2018.
//  Copyright © 2018 deeodus. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene{
    
    let playButton = SKSpriteNode(imageNamed: "start")
    let gameOverLabel = SKLabelNode(text: "Game Over")
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = .orange
        
        gameOverLabel.fontColor = SKColor.black
        gameOverLabel.fontName = "Helvetica"
        gameOverLabel.fontSize = 40
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        addChild(gameOverLabel)
        
        playButton.setScale(0.5)
        playButton.position = CGPoint(x: self.size.width/2, y: self.size.height/4)
        addChild(playButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        if let location = touch?.location(in: self){
            
            if atPoint(location) == playButton{
                
                let gameScene = GameScene(size: self.size)
                let transition = SKTransition.crossFade(withDuration: 1)
                self.view?.presentScene(gameScene, transition: transition)
            }
        }
    }
}
