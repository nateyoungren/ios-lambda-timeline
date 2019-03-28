//
//  VideoPlayerView.swift
//  LambdaTimeline
//
//  Created by Nathanael Youngren on 3/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import AVFoundation
import UIKit

class VideoPlayerView: UIView {
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
