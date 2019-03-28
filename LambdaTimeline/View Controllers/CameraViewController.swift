//
//  CameraViewController.swift
//  LambdaTimeline
//
//  Created by Nathanael Youngren on 3/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import AVFoundation
import UIKit

class CameraViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        let camera = bestCamera()
        
        guard let cameraInput = AVCaptureDeviceInput(device: camera) else {
            fatalError("No input found for device")
        }
        guard captureSession.canAddInput(cameraInput) else {
            fatalError("Cannot add input to session")
        }
        
        captureSession.addInput(cameraInput)
        
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Cannot output session")
        }
        
        captureSession.addOutput(fileOutput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.canSetSessionPreset(.hd1920x1080)
        }
        
        captureSession.commitConfiguration()
        cameraView.session = captureSession
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        }
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        fatalError("No cameras on the device")
    }
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    func updateViews() {
        recordButton.setTitle("", for: .normal)
        if fileOutput.isRecording {
            recordButton.backgroundColor = UIColor.white
            recordButton.layer.cornerRadius = 8
        } else {
            recordButton.backgroundColor = UIColor.red
            recordButton.layer.cornerRadius = recordButton.frame.height / 2
        }
    }
    
    private func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        return fileURL
    }
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var cameraView: CameraPreViewView!
    
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error finishing recording: \(error).")
        }
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
}
