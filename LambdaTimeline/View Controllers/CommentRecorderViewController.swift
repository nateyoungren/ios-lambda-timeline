//
//  CommentRecorderViewController.swift
//  LambdaTimeline
//
//  Created by Nathanael Youngren on 3/26/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class CommentRecorderViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleRecordButton()
        recordButton.setTitle("", for: .normal)
        
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let fileURL = directory.appendingPathComponent(name).appendingPathExtension("caf")
        self.url = fileURL
    }
    
    @IBAction func recordButtonWasTapped(_ sender: UIButton) {
        guard let url = self.url else { return }
        
        recorder.url = url
        recorder.toggleRecording()
        
        styleRecordButton()
    }
    
    @IBAction func playPauseButtonWasTapped(_ sender: UIButton) {
        
    }
    
    func styleRecordButton() {
        
        recordButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        recordButton.widthAnchor.constraint(equalTo: recordButton.heightAnchor).isActive = true
        recordButton.layer.masksToBounds = true
        
        recordButton.layoutIfNeeded()
        
        if recorder.isRecording {
            
            UIView.animate(withDuration: 0.25) {
                self.recordButton.backgroundColor = UIColor.black
                self.recordButton.layer.cornerRadius = 14
            }
            
        } else {
            
            UIView.animate(withDuration: 0.25) {
                self.recordButton.backgroundColor = UIColor.red
                self.recordButton.layer.cornerRadius = 30
            }
        }
    }
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var elapsedTime: UILabel!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var remainingTime: UILabel!
    
    var url: URL?
    
    var recorder = Recorder()
}
