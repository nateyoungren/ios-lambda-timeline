//
//  Recorder.swift
//  LambdaTimeline
//
//  Created by Nathanael Youngren on 3/26/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import AVFoundation

class Recorder: NSObject {
    
    convenience init(url: URL) {
        self.init()
        self.url = url
    }
    
    private func record() {
        guard let url = url,
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 2) else { return }
        
        audioRecorder = try? AVAudioRecorder(url: url, format: format)
        audioRecorder?.delegate = self
        audioRecorder?.record()
    }
    
    private func stop() {
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    func toggleRecording() {
        if isRecording {
            stop()
        } else {
            record()
        }
    }
    
    private var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    var url: URL?
    
    private var audioRecorder: AVAudioRecorder?
}

extension Recorder: AVAudioRecorderDelegate {
    
}
