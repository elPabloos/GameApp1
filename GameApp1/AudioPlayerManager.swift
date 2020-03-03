//
//  AudioPlayerManager.swift
//  GameApp1
//
//  Created by PaulCiudin on 24/02/2020.
//  Copyright © 2020 PaulCiudin. All rights reserved.
//

import AVFoundation

class AudioPlayerManager {
    
    public static let shared = AudioPlayerManager()
    private var audioPlayer: AVAudioPlayer?
    private var soundPlayers: [String : AVAudioPlayer] = [:]
    
    private func initSounds(with URL: URL, resourceName: String, nrOfLoops: Int, volume: Float = 1) {
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: URL)
        } catch {
            print("Error initialising audio player")
        }
        
        audioPlayer?.numberOfLoops = nrOfLoops
        audioPlayer?.setVolume(volume, fadeDuration: 0.3)
        audioPlayer?.prepareToPlay()
        soundPlayers[resourceName] = audioPlayer
    }
    
    public func addPlayer(soundDescription: String, nrOfLoops: Int, volume: Float = 1) {
        guard let url = Bundle.main.url(forResource: soundDescription, withExtension: "mp3") else {
            print("URL with <\(soundDescription)> sound description not found")
            return
        }
        initSounds(with: url, resourceName: soundDescription, nrOfLoops: nrOfLoops, volume: volume)
    }
    
    public func playSound(ofDescription: String) {
        if soundPlayers[ofDescription]?.play() == nil {
            print("Player with <<\(ofDescription)>> sound description not found")
        }
    }
    
    public func setPlayerVolume(ofDescription: String, withVolume: Float, fadeDuration: TimeInterval) {
        if soundPlayers[ofDescription]?.setVolume(withVolume, fadeDuration: fadeDuration) == nil {
            print("Player with <<\(ofDescription)>> sound description not found")
        }
    }
}
