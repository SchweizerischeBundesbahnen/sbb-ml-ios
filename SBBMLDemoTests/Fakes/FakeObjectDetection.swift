//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import Foundation
import Combine
import AVFoundation
@testable import SBBML

class FakeObjectDetection: ObjectDetectionProtocol {
    
    let detectedObjectsSubject = PassthroughSubject<[DetectedObject], Never>()
    var detectedObjectsPublisher: AnyPublisher<[DetectedObject], Never> {
        return detectedObjectsSubject
            .eraseToAnyPublisher()
    }
    
    let errorSubject = PassthroughSubject<ObjectDetectionError?, Never>()
    var errorPublisher: AnyPublisher<ObjectDetectionError?, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var inferencePerformanceAnalysis: InferencePerformanceAnalysisProtocol?
    
    var receivedVideoBuffer: CMSampleBuffer?
    func detectObjects(in videoBuffer: CMSampleBuffer, depthBuffer: CVPixelBuffer?) {
        receivedVideoBuffer = videoBuffer
    }
    
    var stopped = false
    func stop() {
        stopped = true
    }
}
