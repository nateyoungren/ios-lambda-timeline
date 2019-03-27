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
        print(fileURL.path)
        self.url = fileURL
    }
    
    @IBAction func recordButtonWasTapped(_ sender: UIButton) {
        guard let url = self.url else { return }
        
        recorder.url = url
        recorder.toggleRecording()
        
        styleRecordButton()
        player = Player(url: url)
        player?.delegate = self
    }
    
    @IBAction func playPauseButtonWasTapped(_ sender: UIButton) {
        guard let player = player else { return }
        player.togglePlayPause()
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        guard let postController = postController, post != nil, let url = url else {
            print("Post or PostController is missing.")
            return
        }
        postController.addComment(withAudio: url, to: &self.post!)
        dismiss(animated: true, completion: nil)
    }
    
    func styleRecordButton() {
        
        if player != nil {
            updatePlayerViews()
        } else {
            audioSlider.alpha = 0
            playButton.alpha = 0
            elapsedTime.alpha = 0
            remainingTime.alpha = 0
            sendButton.alpha = 0
        }
        
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
    
    func updatePlayerViews() {
        guard let player = player else { return }
        audioSlider.alpha = 1
        playButton.alpha = 1
        elapsedTime.alpha = 1
        remainingTime.alpha = 1
        sendButton.alpha = 1
        
        if player.isPlaying {
            playButton.setTitle("||", for: .normal)
            playButton.tintColor = UIColor.black
        } else {
            playButton.setTitle("➜", for: .normal)
            playButton.tintColor = UIColor.red
        }
        
        elapsedTime.text = timeFormatter.string(from: player.currentTime)
        remainingTime.text = timeFormatter.string(from: player.remainingTime)
        
        audioSlider.maximumValue = Float(player.duration)
        audioSlider.minimumValue = 0
        audioSlider.value = Float(player.currentTime)
        
        sendButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        sendButton.widthAnchor.constraint(equalTo: sendButton.heightAnchor).isActive = true
        
        sendButton.layer.cornerRadius = 10
        sendButton.layer.masksToBounds = true
        
        sendButton.backgroundColor = UIColor.blue
        sendButton.tintColor = UIColor.white
        sendButton.setTitle("↑", for: .normal)
    }
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var elapsedTime: UILabel!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var remainingTime: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    var url: URL?
    
    let recorder = Recorder()
    var player: Player?
    
    var post: Post?
    var postController: PostController?
    
    private lazy var timeFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.unitsStyle = .positional
        f.zeroFormattingBehavior = .pad
        f.allowedUnits = [.minute, .second]
        return f
    }()
}

extension CommentRecorderViewController: PlayerDelegate {
    
    func playerDidChangeState(player: Player) {
        updatePlayerViews()
    }
}
