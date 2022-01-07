//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import Foundation
import Combine
import AVFoundation

protocol ObjectTrackingProtocol {
    var trackedObjectsPublisher: AnyPublisher<[DetectedObject], Never> { get }
    var previewLayer: AVCaptureVideoPreviewLayer? { get set }
    var isTracking: Bool { get }

    func startTracking(objects: [DetectedObject])
    func stopTracking()
    func updateTrackedObjects(in sampleBuffer: CMSampleBuffer)
}
