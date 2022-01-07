//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import Foundation
import Combine
import AVFoundation
import UIKit
import Vision

class ObjectTracking: ObjectTrackingProtocol {
    var trackedObjectsPublisher: AnyPublisher<[DetectedObject], Never> {
        trackedObjectsSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    private let trackedObjectsSubject = CurrentValueSubject<[DetectedObject], Never>([DetectedObject]())
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    var isTracking: Bool {
         if objectsBeingTracked != nil && inputObservations != nil && requestHandler != nil  {
            return true
         } else {
            return false
         }
    }

    private var trackingLevel = VNRequestTrackingLevel.accurate
    private var confidenceThreshold: VNConfidence
    private var objectsBeingTracked: [DetectedObject]?
    private var inputObservations: [UUID: VNDetectedObjectObservation]?
    private var requestHandler: VNSequenceRequestHandler?
    
    init(confidenceThreshold: VNConfidence) {
        self.confidenceThreshold = confidenceThreshold
    }
    
    func startTracking(objects: [DetectedObject]) {
        objectsBeingTracked = objects
        inputObservations = [UUID: VNDetectedObjectObservation]()
        for object in objects {
            let inputObservation = VNDetectedObjectObservation(boundingBox: object.rect)
            inputObservations?[object.id] = inputObservation
        }
        requestHandler = VNSequenceRequestHandler()
    }
    
    func stopTracking() {
        inputObservations = nil
        requestHandler = nil
    }
    
    func updateTrackedObjects(in sampleBuffer: CMSampleBuffer) {
        guard let trackedObjects = objectsBeingTracked, let inputObservations = inputObservations, let requestHandler = requestHandler else {
            Logger.log("ObjectTracker: trackObjects() called but objects are not yet initialized. You need to call startTracking() first.", .debug)
            return
        }
        
        guard let previewLayer = previewLayer else {
            Logger.log("ObjectTracker: trackObjects() called but the previewLayer is not yet set. You need to set the previewLayer first.", .debug)
            return
        }
        
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            Logger.log("ObjectTracker: Could not create CVImageBuffer from CMSampleBuffer.", .debug)
            return
        }
        
        var trackingRequests = [VNRequest]()
        var updatedTrackedObjects = [DetectedObject]()
        var updatedInputObservations = [UUID: VNDetectedObjectObservation]()
        for inputObservation in inputObservations {
            let request = VNTrackObjectRequest(detectedObjectObservation: inputObservation.value) { (request, error) in
                guard let results = request.results, let observation = results.first as? VNDetectedObjectObservation else {
                    return
                }
                
                updatedInputObservations[inputObservation.key] = observation
                
                if observation.confidence > self.confidenceThreshold {
                    guard var trackedObject = (trackedObjects.first { $0.id == inputObservation.key }) else {
                        return
                    }
                    
                    // convert to rect in screen
                    let convertedBoundingBoxForCurrentDeviceOrientation = observation.boundingBox.convertForCurrentDeviceOrientation()
                    let boundingBoxInPreviewLayer = previewLayer.layerRectConverted(fromMetadataOutputRect: convertedBoundingBoxForCurrentDeviceOrientation)
                    trackedObject.rect = observation.boundingBox
                    trackedObject.rectInPreviewLayer = boundingBoxInPreviewLayer
                    updatedTrackedObjects.append(trackedObject)
                }
            }
           
            request.trackingLevel = trackingLevel
            trackingRequests.append(request)
        }
                
        // Perform requests
        let currentDeviceOrientation = UIDevice.current.orientation
        do {
            try requestHandler.perform(trackingRequests, on: frame, orientation: currentDeviceOrientation.exifOrientation)
        } catch {
            Logger.log("ObjectTracker: Tracking failed for at least one object.", .debug)
        }

        self.inputObservations = updatedInputObservations   // the updated observations should be used for the next iteration
        
        DispatchQueue.main.async {
            self.trackedObjectsSubject.send(updatedTrackedObjects)
        }
    }
}
