//
//  CameraPresentViewController.swift
//  LambdaTimeline
//
//  Created by Nathanael Youngren on 3/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import AVFoundation
import UIKit

class CameraPresentViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            presentCamera()
        case .denied:
            fatalError("User has denied permission to use camera for video.")
        case .notDetermined:
            
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status == false {
                    fatalError("Please request user to enable camera in Privacy.")
                }
                DispatchQueue.main.async {
                    self.presentCamera()
                }
            }
        case .restricted:
            fatalError("User has restricted permission to use camera for video.")
        }
    }
    
    func presentCamera() {
        performSegue(withIdentifier: "ShowCamera", sender: self)
    }
}
