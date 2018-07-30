//
//  ImagePickerViewController.swift
//  SnapchatCloneV3
//
//  Created by Anish Saha on 4/12/16.
//  Copyright © 2016 asaha. All rights reserved.
//

import UIKit
import AVFoundation

class ImagePickerViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    @IBOutlet weak var imageViewOverlay: UIImageView!
    @IBOutlet weak var flipCameraButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var sendImageButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var selectedImage = UIImage()
    let captureSession = AVCaptureSession()
    var captureDevice : AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    let photoOutput = AVCapturePhotoOutput()
    
    
    func selectImage(_ image: UIImage) {
        selectedImage = image
    }
    
    override func viewDidLoad() {
        captureNewSession(devicePostion: AVCaptureDevicePosition.front)
        super.viewDidLoad()
        toggleUI(isInPreviewMode: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func captureNewSession(devicePostion: AVCaptureDevicePosition) {
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                captureSession.removeInput(input)
            }
        }
        
        captureSession.stopRunning()
        
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        if let deviceDiscoverySession = AVCaptureDeviceDiscoverySession.init(deviceTypes: [AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.unspecified) {
            
            for device in deviceDiscoverySession.devices {
                if (device.hasMediaType(AVMediaTypeVideo)) {
                    if (device.position == devicePostion) {
                        captureDevice = device
                        if captureDevice != nil {
                            do {
                                try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
                                if captureSession.canAddOutput(photoOutput) {
                                    captureSession.addOutput(photoOutput)
                                }
                            }
                            catch {
                                print("error: \(error.localizedDescription)")
                            }
                            
                            if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
                                view.layer.addSublayer(previewLayer)
                                previewLayer.frame = view.layer.frame
                                captureSession.startRunning()
                            }
                        }
                    }
                }
            }
        }
    }
    
 
    @IBAction func takePhoto(_ sender: UIButton) {
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        photoOutput.capturePhoto(with: settingsForMonitoring, delegate: self)
    }
    
    @IBAction func flipCamera(_ sender: UIButton) {
        if (captureDevice?.position == AVCaptureDevicePosition.front) {
            captureNewSession(devicePostion: AVCaptureDevicePosition.back)
        }
        else {
            captureNewSession(devicePostion: AVCaptureDevicePosition.front)
        }
        toggleUI(isInPreviewMode: false)
    }
    
    // MARK: AVCapturePhotoCaptureDelegate
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let photoSampleBuffer = photoSampleBuffer {
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            selectedImage = UIImage(data: photoData!)!
            toggleUI(isInPreviewMode: true)
        }
    }
    
    func toggleUI(isInPreviewMode: Bool) {
        if isInPreviewMode {
            imageViewOverlay.image = selectedImage
            takePhotoButton.isHidden = true
            sendImageButton.isHidden = false
            cancelButton.isHidden = false
            flipCameraButton.isHidden = true
            
        }
        else {
            takePhotoButton.isHidden = false
            sendImageButton.isHidden = true
            cancelButton.isHidden = true
            imageViewOverlay.image = nil
            flipCameraButton.isHidden = false
        }
        
        view.bringSubview(toFront: imageViewOverlay)
        view.bringSubview(toFront: sendImageButton)
        view.bringSubview(toFront: takePhotoButton)
        view.bringSubview(toFront: flipCameraButton)
        view.bringSubview(toFront: cancelButton)
    }
    
    @IBAction func cancelButtonWasPressed(_ sender: UIButton) {
        selectedImage = UIImage()
        toggleUI(isInPreviewMode: false)
    }
    
    @IBAction func sendImage(_ sender: UIButton) {
        performSegue(withIdentifier: "imagePickerToChooseThread", sender: nil)
    }
    
    @IBAction func unwindToImagePicker(segue: UIStoryboardSegue) {
        toggleUI(isInPreviewMode: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationController?.navigationBar.isHidden = false
        let destination = segue.destination as! ChooseThreadViewController
        destination.chosenImage = selectedImage
        toggleUI(isInPreviewMode: false)
    }
}
