//
//  ViewController.swift
//  GameApp1
//
//  Created by PaulCiudin on 22/02/2020.
//  Copyright © 2020 PaulCiudin. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSoundPlayers()
        
        let skview = view as! SKView
        
        print(skview.debugDescription)
        skview.presentScene(StartScene(size: view.bounds.size ))
        skview.showsPhysics = false
        skview.showsFPS = true
        skview.showsNodeCount = true
    }
    
    private func addSoundPlayers() {
//        AudioPlayerManager.shared.addPlayer(soundDescription: "music", nrOfLoops: -1)
        AudioPlayerManager.shared.addPlayer(soundDescription: "eating", nrOfLoops: 0)
        AudioPlayerManager.shared.addPlayer(soundDescription: "burp", nrOfLoops: 0)
    }
}

