//
//  CommentRecorderViewController.swift
//  LambdaTimeline
//
//  Created by Nathanael Youngren on 3/26/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class CommentRecorderViewController: UIViewController {
    
    @IBAction func recordButtonWasTapped(_ sender: UIButton) {
    
    }
    
    @IBAction func playPauseButtonWasTapped(_ sender: UIButton) {
        
    }
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var elapsedTime: UILabel!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var remainingTime: UILabel!
}
