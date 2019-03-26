//
//  Player.swift
//  LambdaTimeline
//
//  Created by Nathanael Youngren on 3/26/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import AVFoundation

class Player: NSObject {
    
    override init() {
        super.init()
    }
    
    func play() {
        
    }
    
    func pause() {
        
    }
    
    func togglePlayPause() {
        
    }
    
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    private var audioPlayer: AVAudioPlayer?
}
