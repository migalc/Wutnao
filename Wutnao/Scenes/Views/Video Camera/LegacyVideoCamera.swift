//
//  LegacyVideoCamera.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 03/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//
// MIGUEL: Based on https://www.appcoda.com/qr-code-reader-swift/

// MARK: - Imports

import UIKit
import Foundation
import AVFoundation

// MARK: - Protocols

protocol LegacyVideoCameraDelegate: NSObjectProtocol {
    func videoCapture(buffer: CMSampleBuffer?, bounds: CGRect)
}

protocol LegacyVideoCameraProtocol {
    func prepareCamera(sessionPreset: AVCaptureSession.Preset)
    func startReading()
    func stopReading()
    func focus(on autoFocusPoint: CGPoint)
}

// MARK: - AVKit Video Camera Implementation

class LegacyVideoCamera: UIView, LegacyVideoCameraProtocol {
    
    // MARK: - Properties

    var delegate: LegacyVideoCameraDelegate?

    private var _device: AVCaptureDevice!
    private var _captureSession: AVCaptureSession!
    private var _videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private var _videoOutput = AVCaptureVideoDataOutput()
    private var _lastTimestamp = CMTime()
    private let _fps = 15
    private var _parentView: UIView = .init(frame: .zero)
    
    // MARK: - Initializers
    
    init(parentView: UIView) {
        _parentView = parentView
        super.init(frame: parentView.frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - View Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _videoPreviewLayer.frame = bounds
    }
    
    // MARK: - Protocol functions
    
//    func prepareCamera(sessionPreset: AVCaptureSession.Preset = .vga640x480) {
    func prepareCamera(sessionPreset: AVCaptureSession.Preset = .iFrame960x540) {
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        _device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                          for: .video,
                                          position: .back)
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        guard _device != nil, let input = try? AVCaptureDeviceInput(device: _device!) else { return }

        // Initialize the captureSession object.
        _captureSession = AVCaptureSession()
        _captureSession.sessionPreset = sessionPreset
        
        // Set the input device on the capture session.
        _captureSession?.addInput(input)
        
        let settings: [String : Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA),
        ]
        
        let queue = DispatchQueue.init(label: "visionQueue")
        
        _videoOutput.videoSettings = settings
        _videoOutput.alwaysDiscardsLateVideoFrames = true
        _videoOutput.setSampleBufferDelegate(self, queue: queue)
        if _captureSession.canAddOutput(_videoOutput) {
            _captureSession.addOutput(_videoOutput)
        }
        
        // We want the buffers to be in portrait orientation otherwise they are
        // rotated by 90 degrees. Need to set this _after_ addOutput()!
        _videoOutput.connection(with: .video)?.videoOrientation = .portrait
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: _captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = bounds
        previewLayer.connection?.videoOrientation = .portrait
        _videoPreviewLayer = previewLayer
        
        _videoPreviewLayer?.session = _captureSession

        _parentView.layer.insertSublayer(_videoPreviewLayer, at: 0)
    }
    
    func startReading() {
        guard !_captureSession.isRunning else { return }
        
        // Start video capture.
        _captureSession?.startRunning()
    }

    func stopReading() {
        _captureSession?.stopRunning()
    }
    
    func focus(on autoFocusPoint: CGPoint) {
        guard let dvc = _device, dvc.isFocusModeSupported(.continuousAutoFocus) && dvc.isFocusPointOfInterestSupported else { return }
        
        try? _device?.lockForConfiguration()
        _device?.focusPointOfInterest = autoFocusPoint
        _device?.focusMode = .autoFocus
        _device?.unlockForConfiguration()
    }
    
    // MARK: - Private functions

    private func setupCamera() {
        NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil) { [unowned self] (notification) in
            guard let device = notification.object as? UIDevice,
                let videoOrientation = AVCaptureVideoOrientation(rawValue: device.orientation.rawValue) else { return }
            self._videoOutput.connection(with: .video)?.videoOrientation = videoOrientation
            self._videoPreviewLayer.connection?.videoOrientation = videoOrientation
        }
        checkHasAuthorization { [weak self] (isGranted) in
            guard let self = self else { return }
            guard isGranted else { return }
            self.prepareCamera()
        }
    }

    private func checkHasAuthorization(completion: ((Bool) -> Void)?) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            completion?(true)
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion?(granted)
            }
        default:
            completion?(false)
            return
        }
    }
}

// MARK: - AV Output Delegates

extension LegacyVideoCamera: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let timestamp = sampleBuffer.presentationTimeStamp
        let deltaTime = timestamp - _lastTimestamp
        
        guard deltaTime >= CMTimeMake(value: 1, timescale: Int32(_fps)) else { return }
        _lastTimestamp = timestamp
        DispatchQueue.main.async {
            self.delegate?.videoCapture(buffer: sampleBuffer, bounds: self.bounds)
        }
        
    }
    
    public func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        print("dropped frame")
    }
}
