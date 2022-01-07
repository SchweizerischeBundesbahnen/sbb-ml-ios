//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import Combine
import AVFoundation
import UIKit

protocol CameraControllerProtocol {
    
    var cameraOutputPublisher: AnyPublisher<CameraOutput?, Never> { get }
    var errorPublisher: AnyPublisher<ObjectDetectionError?, Never> { get }
    var previewLayer: AVCaptureVideoPreviewLayer { get }
    
    func requestCameraAuthorizationAndConfigureCaptureSession()

    func displayPreview(on view: UIView)
    
    func removePreview()
    
    func updatePreview(for bounds: CGRect, deviceOrientation: UIDeviceOrientation)
}
