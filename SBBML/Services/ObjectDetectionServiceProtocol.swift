//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import Foundation
import Combine

/// A protocol implemented by ``ObjectDetectionService`` which can be used to enable unit testing your ViewModel by using a fake ObjectDetectionService.
public protocol ObjectDetectionServiceProtocol {
    
    /// Publishes all ``DetectedObject``s (and updates their frames).
    var detectedObjectsPublisher: AnyPublisher<[DetectedObject], Never> { get }
    
    /// Publishes all ``ObjectDetectionError``s occuring during the usage of ``ObjectDetectionService``.
    var errorPublisher: AnyPublisher<ObjectDetectionError?, Never> { get }
    
    /// Publishes the inference time of every object detection iteration during the usage of ``ObjectDetectionService``
    var currentObjectDetectionInferenceTimePublisher: AnyPublisher<TimeInterval, Never> { get }
    
    /// Requests authorization for media capture (camera) and configures the AVCaptureDevice. By default, camera authorization is automatically requested when ``CameraStreamView`` appears for the first time on the screen. However you can also trigger the prompt manually by calling ``requestCameraAuthorization()`` (e.g. during Onboarding).
    func requestCameraAuthorization()
}
