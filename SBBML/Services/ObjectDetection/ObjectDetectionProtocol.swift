//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import Foundation
import Combine
import AVFoundation

protocol ObjectDetectionProtocol {
    
    var detectedObjectsPublisher: AnyPublisher<[DetectedObject], Never> { get }
    var errorPublisher: AnyPublisher<ObjectDetectionError?, Never> { get }
    var previewLayer: AVCaptureVideoPreviewLayer? { get set }
    var inferencePerformanceAnalysis: InferencePerformanceAnalysisProtocol? { get }
    
    func detectObjects(in videoBuffer: CMSampleBuffer, depthBuffer: CVPixelBuffer?)
    func stop()
}
