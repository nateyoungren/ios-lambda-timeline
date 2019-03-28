//
//  VideoPlaybackViewController.swift
//  LambdaTimeline
//
//  Created by Nathanael Youngren on 3/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import AVFoundation
import UIKit

class VideoPlaybackViewController: UIViewController {
    
    func prepareToPlay() {
        
        guard let url = url else {
            fatalError("No URL found")
        }
        
        let asset = AVAsset(url: url)
        let assetKeys = [
            "playable",
            "readable",
            "exportable"
        ]
        
        
    }
    
    var url: URL?
    
    lazy private var videoPlayer = AVPlayer()
}
