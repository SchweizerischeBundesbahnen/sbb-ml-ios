//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import Foundation
import Combine
import AVFoundation
@testable import SBBML

class FakeObjectTracking: ObjectTrackingProtocol {
    
    let trackedObjectsSubject = PassthroughSubject<[DetectedObject], Never>()
    var trackedObjectsPublisher: AnyPublisher<[DetectedObject], Never> {
        return trackedObjectsSubject.eraseToAnyPublisher()
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var fakeIsTracking: Bool = false
    var isTracking: Bool {
        return fakeIsTracking
    }
    
    var receivedObjects: [DetectedObject]?
    func startTracking(objects: [DetectedObject]) {
        receivedObjects = objects
    }
    
    var stoppedTracking = false
    func stopTracking() {
        stoppedTracking = true
    }
    
    var receivedSampleBuffer: CMSampleBuffer?
    func updateTrackedObjects(in sampleBuffer: CMSampleBuffer) {
        receivedSampleBuffer = sampleBuffer
    }
    
    
}
