//
//  CameraPreViewView.swift
//  LambdaTimeline
//
//  Created by Nathanael Youngren on 3/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPreViewView: UIView {
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreViewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get { videoPreViewLayer.session }
        set { videoPreViewLayer.session = newValue }
    }
}
