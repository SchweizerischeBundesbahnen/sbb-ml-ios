//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import Foundation
import Combine
import AVFoundation
import UIKit
@testable import SBBML

class FakeCameraController: CameraControllerProtocol {
    
    let cameraOutputSubject = PassthroughSubject<CameraOutput?, Never>()
    var cameraOutputPublisher: AnyPublisher<CameraOutput?, Never> {
        return cameraOutputSubject.eraseToAnyPublisher()
    }
    
    let errorSubject = PassthroughSubject<ObjectDetectionError?, Never>()
    var errorPublisher: AnyPublisher<ObjectDetectionError?, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer
    
    init() {
        self.previewLayer = AVCaptureVideoPreviewLayer()
    }
    
    var requestCameraAuthorizationAndConfigureCaptureSessionCalled = false
    func requestCameraAuthorizationAndConfigureCaptureSession() {
        requestCameraAuthorizationAndConfigureCaptureSessionCalled = true
    }
    
    var receivedView: UIView?
    func displayPreview(on view: UIView) {
        receivedView = view
    }
    
    var removedPreview = false
    func removePreview() {
        removedPreview = true
    }
    
    var receivedBounds: CGRect?
    var receivedDeviceOrientation: UIDeviceOrientation?
    func updatePreview(for bounds: CGRect, deviceOrientation: UIDeviceOrientation) {
        receivedBounds = bounds
        receivedDeviceOrientation = deviceOrientation
    }
}
