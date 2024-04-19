//
//  SoundManager.swift
//  PoketDex
//
//  Created by Aman Giri on 2024-04-17.
//

import Foundation
import OggDecoder
import AVKit

class SoundManager{
    static let instance = SoundManager()
    
    var player:AVAudioPlayer?
    
    func playSound(for pokemon: Int){
//        guard let url = Bundle.main.url(forResource: "\(pokemon)", withExtension: ".ogg") else {
//            return print("Couldn't find the Paper.mp3")
//            
//        }
//
        
        guard let urlpath = Bundle.main.url(forResource: "\(pokemon)", withExtension: "ogg") else {
            return print("Couldn't find the urlpath")
        }
        do{
            let decoder = OGGDecoder()
            if let decodedURL = decoder.decode(urlpath){
                do {
                    player = try AVAudioPlayer(contentsOf: decodedURL)
                    player?.play()
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            } else {
                print("Couldn't decode")
            }
            
        }
    }
}
