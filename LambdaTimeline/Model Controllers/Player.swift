//
//  Player.swift
//  LambdaTimeline
//
//  Created by Nathanael Youngren on 3/26/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import AVFoundation

protocol PlayerDelegate: AnyObject {
    func playerDidChangeState(player: Player)
}

class Player: NSObject {
    
    convenience init(url: URL) {
        self.init()
        self.url = url
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.delegate = self
    }
    
    func play() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.play()
        notifyDelegate()
        
        cancelTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (_) in
            self.notifyDelegate()
        })
    }
    
    func pause() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.pause()
        notifyDelegate()
    }
    
    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func notifyDelegate() {
        delegate?.playerDidChangeState(player: self)
    }
    
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    var currentTime: TimeInterval {
        return audioPlayer!.currentTime
    }
    
    var duration: TimeInterval {
        return audioPlayer!.duration
    }
    
    var remainingTime: TimeInterval {
        return duration - currentTime
    }
    
    var url: URL?
    weak var delegate: PlayerDelegate?
    private var audioPlayer: AVAudioPlayer?
    var timer: Timer?
}

extension Player: AVAudioPlayerDelegate {
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print(error)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        notifyDelegate()
    }
}
