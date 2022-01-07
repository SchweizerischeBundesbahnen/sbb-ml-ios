//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import UIKit
import AVFoundation
import Combine

class CameraController: NSObject, CameraControllerProtocol {
    
    var cameraOutputPublisher: AnyPublisher<CameraOutput?, Never> {
        cameraOutputSubject
            .eraseToAnyPublisher()
    }
    private let cameraOutputSubject = CurrentValueSubject<CameraOutput?, Never>(nil)
    
    var errorPublisher: AnyPublisher<ObjectDetectionError?, Never> {
        errorSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    private let errorSubject = CurrentValueSubject<ObjectDetectionError?, Never>(nil)
        
    var previewLayer: AVCaptureVideoPreviewLayer
    private let captureSession: AVCaptureSession
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let depthDataOutput = AVCaptureDepthDataOutput()
    private var outputSynchronizer: AVCaptureDataOutputSynchronizer?
    private let previewVideoGravity: AVLayerVideoGravity
    private var depthRecordingEnabled: Bool
    private var currentDeviceSupportsDepthRecording = false
        
    init(previewVideoGravity: AVLayerVideoGravity, depthRecordingEnabled: Bool) {
        self.previewVideoGravity = previewVideoGravity
        self.depthRecordingEnabled = depthRecordingEnabled
        let captureSession = AVCaptureSession()
        self.captureSession = captureSession
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        super.init()
    }
    
    func requestCameraAuthorizationAndConfigureCaptureSession() {
        configure(depthRecordingEnabled: depthRecordingEnabled)
    }
        
    func displayPreview(on view: UIView) {
        self.previewLayer.videoGravity = previewVideoGravity
        
        view.layer.insertSublayer(self.previewLayer, at: 0)
        self.previewLayer.frame = view.frame
        
        self.captureSession.startRunning()
    }
    
    func removePreview() {
        self.previewLayer.removeFromSuperlayer()
        self.captureSession.stopRunning()
    }
    
    func updatePreview(for bounds: CGRect, deviceOrientation: UIDeviceOrientation) {
        previewLayer.frame = bounds
        
        switch deviceOrientation {
        case .landscapeLeft:
            previewLayer.connection?.videoOrientation = .landscapeRight
        case .landscapeRight:
            previewLayer.connection?.videoOrientation = .landscapeLeft
        case .portraitUpsideDown:
            previewLayer.connection?.videoOrientation = .portraitUpsideDown
        case .portrait:
            previewLayer.connection?.videoOrientation = .portrait
        default:
            previewLayer.connection?.videoOrientation = .portrait
        }
    }
    
    private func configure(depthRecordingEnabled: Bool) {
        self.depthRecordingEnabled = depthRecordingEnabled
        DispatchQueue(label: "prepare").async {
            guard AVCaptureDevice.authorizationStatus(for: .video) != .denied else {
                self.errorSubject.send(.deniedCameraAuthorization)
                return
            }
            
            guard self.captureSession.outputs.isEmpty && self.captureSession.inputs.isEmpty else {
                // return, since configure has already been called
                return
            }
            
            do {
                let camera = try self.configureCaptureDevices(depthRecordingEnabled: depthRecordingEnabled)
                try self.configureDeviceInputs(for: camera)
                try self.configureDeviceOutputs(depthRecordingEnabled: depthRecordingEnabled)
            } catch let error as ObjectDetectionError {
                self.errorSubject.send(error)
            } catch {
                Logger.log("Unknown error while trying to configure CameraController: \(error)", .error)
            }
        }
    }
    
    private func configureCaptureDevices(depthRecordingEnabled: Bool) throws -> AVCaptureDevice {
        guard let camera = availableCaptureDevice(depthRecordingEnabled: depthRecordingEnabled) else {
            throw ObjectDetectionError.noCamerasAvailable
        }
        
        try camera.lockForConfiguration()
        if camera.deviceType == .builtInDualWideCamera {
            // Search for highest resolution with half-point depth values
            let depthFormats = camera.activeFormat.supportedDepthDataFormats
            let filtered = depthFormats.filter({
                CMFormatDescriptionGetMediaSubType($0.formatDescription) == kCVPixelFormatType_DepthFloat16
            })
            let selectedFormat = filtered.max(by: {
                first, second in CMVideoFormatDescriptionGetDimensions(first.formatDescription).width < CMVideoFormatDescriptionGetDimensions(second.formatDescription).width
            })
            camera.activeDepthDataFormat = selectedFormat
        }
        camera.unlockForConfiguration()
        
        return camera
    }
    
    private func availableCaptureDevice(depthRecordingEnabled: Bool) -> AVCaptureDevice? {
        if depthRecordingEnabled, let device = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back) {
            currentDeviceSupportsDepthRecording = true
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        } else {
            return nil
        }
    }
    
    private func configureDeviceInputs(for camera: AVCaptureDevice) throws {
        let cameraInput = try AVCaptureDeviceInput(device: camera)
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .vga640x480 // higher resolution is critical because it will lead to buffers being dropped
        
        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
        } else {
            captureSession.commitConfiguration()
            throw ObjectDetectionError.inputsAreInvalid
        }
        
        captureSession.commitConfiguration()
    }
    
    private func configureDeviceOutputs(depthRecordingEnabled: Bool) throws {
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
            
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        } else {
            captureSession.commitConfiguration()
            throw ObjectDetectionError.outputsAreInvalid
        }
        
        if depthRecordingEnabled && currentDeviceSupportsDepthRecording {
            if captureSession.canAddOutput(depthDataOutput) {
                captureSession.addOutput(depthDataOutput)
                depthDataOutput.isFilteringEnabled = true
                if let connection = depthDataOutput.connection(with: .depthData) {
                    connection.isEnabled = true
                } else {
                    Logger.log("No AVCaptureConnection", .error)
                }
            } else {
                captureSession.commitConfiguration()
                throw ObjectDetectionError.outputsAreInvalid
            }
        }
        
        let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
        if depthRecordingEnabled && currentDeviceSupportsDepthRecording {
            outputSynchronizer = AVCaptureDataOutputSynchronizer(dataOutputs: [videoDataOutput, depthDataOutput])
            outputSynchronizer!.setDelegate(self, queue: videoDataOutputQueue)
        } else {
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        }
        
        captureSession.commitConfiguration()
    }
}

// Using AVCaptureVideoDataOutputSampleBufferDelegate if DepthData is not enabled
extension CameraController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        cameraOutputSubject.send(CameraOutput(videoBuffer: sampleBuffer, depthBuffer: nil))
    }
}

// Using AVCaptureDataOutputSynchronizerDelegate if DepthData is enabled
extension CameraController: AVCaptureDataOutputSynchronizerDelegate {
    func dataOutputSynchronizer(_ synchronizer: AVCaptureDataOutputSynchronizer, didOutput synchronizedDataCollection: AVCaptureSynchronizedDataCollection) {
        guard let syncedVideoData: AVCaptureSynchronizedSampleBufferData =
            synchronizedDataCollection.synchronizedData(for: videoDataOutput) as? AVCaptureSynchronizedSampleBufferData, let syncedDepthData: AVCaptureSynchronizedDepthData =
                synchronizedDataCollection.synchronizedData(for: depthDataOutput) as? AVCaptureSynchronizedDepthData else {
            Logger.log("DataOutputSynchronizer no depth output", .debug)
            return
        }
        
        if syncedVideoData.sampleBufferWasDropped || syncedDepthData.depthDataWasDropped {
            Logger.log("DataOutputSynchronizer dropped sampleBuffer or depthData: \(syncedVideoData.droppedReason)", .debug)
            // see https://developer.apple.com/library/archive/technotes/tn2445/_index.html for fixes if buffers are dropped frequently (freezing Preview layer)
            return
        }
        
        let sampleBuffer = syncedVideoData.sampleBuffer
        let depthData = syncedDepthData.depthData
        let depthPixelBuffer = depthData.depthDataMap
        
        cameraOutputSubject.send(CameraOutput(videoBuffer: sampleBuffer, depthBuffer: depthPixelBuffer))
    }
}
