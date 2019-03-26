//
//  ImagePostViewController.swift
//  LambdaTimeline
//
//  Created by Spencer Curtis on 10/12/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import Photos

class ImagePostViewController: ShiftableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImageViewHeight(with: 1.0)
        
        updateViews()
        
        currentFilter = CIFilter(name: "CIColorControls")!
    }
    
    func updateViews() {
        
        guard let imageData = imageData,
            let image = UIImage(data: imageData) else {
                title = "New Post"
                return
        }
        
        title = post?.title
        
        setImageViewHeight(with: image.ratio)
        
        imageView.image = image
        
        chooseImageButton.setTitle("", for: [])
    }
    
    private func presentImagePickerController() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary

        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func createPost(_ sender: Any) {
        
        view.endEditing(true)
        
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.1),
            let title = titleTextField.text, title != "" else {
            presentInformationalAlertController(title: "Uh-oh", message: "Make sure that you add a photo and a caption before posting.")
            return
        }
        
        postController.createPost(with: title, ofType: .image, mediaData: imageData, ratio: imageView.image?.ratio) { (success) in
            guard success else {
                DispatchQueue.main.async {
                    self.presentInformationalAlertController(title: "Error", message: "Unable to create post. Try again.")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
                    return
                }
                
                self.presentImagePickerController()
            }
            
        case .denied:
            self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
        case .restricted:
            self.presentInformationalAlertController(title: "Error", message: "Unable to access the photo library. Your device's restrictions do not allow access.")
            
        }
        presentImagePickerController()
    }
    
    func setImageViewHeight(with aspectRatio: CGFloat) {
        
        imageHeightConstraint.constant = imageView.frame.size.width * aspectRatio
        
        view.layoutSubviews()
    }
    
    // - MARK: Sliders
    
    @IBAction func brightnessSliderValueChanged(_ sender: UISlider) {
        currentFilter = CIFilter(name: "CIColorControls")!
        applyFilter()
    }
    
    @IBAction func contrastSliderValueChanged(_ sender: UISlider) {
        currentFilter = CIFilter(name: "CIColorControls")!
        applyFilter()
    }
    
    @IBAction func saturationSliderValueChanged(_ sender: UISlider) {
        currentFilter = CIFilter(name: "CIColorControls")!
        applyFilter()
    }
    
    @IBAction func temperatureSliderValueChanged(_ sender: UISlider) {
        currentFilter = CIFilter(name: "CITemperatureAndTint")!
        tint = CIVector(cgPoint: CGPoint(x: Int(sender.value), y: 0))
        applyFilter()
    }
    
    @IBAction func invertSwitched(_ sender: UISwitch) {
        currentFilter = CIFilter(name: "CIColorInvert")!
        if sender.isOn {
            isInverted = true
        } else {
            isInverted = false
        }
        applyFilter()
    }
    
    // - MARK: Image filtering
    
    private func applyFilter() {
        
        guard let imageData = self.imageData else { return }
        
        guard let uiImage = UIImage(data: imageData) else { return }
        guard let cgImage = uiImage.cgImage else { return }
        let ciImage = CIImage(cgImage: cgImage)
        
        currentFilter.setValue(ciImage, forKey: kCIInputImageKey)
        let keys = currentFilter.inputKeys
        
        if keys.contains("inputNeutralTarget") {
            currentFilter.setValue(tint, forKey: "inputNeutralTarget")
        }
        
        if keys.contains(kCIInputBrightnessKey) {
            currentFilter.setValue(brightnessSlider.value, forKey: kCIInputBrightnessKey)
        }
        
        if keys.contains(kCIInputContrastKey) {
            currentFilter.setValue(contrastSlider.value, forKey: kCIInputContrastKey)
        }
        
        if keys.contains(kCIInputSaturationKey) {
            currentFilter.setValue(saturationSlider.value, forKey: kCIInputSaturationKey)
        }
        
        guard let outputCIImage = currentFilter.outputImage else { return }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return }
        guard let data = UIImage(cgImage: outputCGImage).pngData() else { return }
        
        self.imageData = data
    }
    
    var postController: PostController!
    var post: Post?
    var imageData: Data? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var contrastSlider: UISlider!
    @IBOutlet weak var saturationSlider: UISlider!
    @IBOutlet weak var temperatureSlider: UISlider!
    @IBOutlet weak var invertSwitch: UISwitch!
    
    private var tint: CIVector?
    
    private var isInverted: Bool = false
    
    private let context = CIContext(options: nil)
    var currentFilter: CIFilter!
}

extension ImagePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        chooseImageButton.setTitle("", for: [])
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        imageView.image = image
        
        self.imageData = image.pngData()
        
        setImageViewHeight(with: image.ratio)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
