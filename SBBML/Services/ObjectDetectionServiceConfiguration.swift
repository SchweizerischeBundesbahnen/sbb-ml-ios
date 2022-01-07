//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import AVFoundation
import CoreML
import Vision

/// A Struct who let's you configure the ``CameraStreamView`` and ObjectDetection parameters, if you don't wish to the standard (optimized) configuration. To use SBB ML with your own configuration, pass your custom ``ObjectDetectionServiceConfiguration`` in the init function of ``ObjectDetectionService``.
public struct ObjectDetectionServiceConfiguration: Equatable {
    
    /// The minimum confidence value every detected object needs to match, normalized to [0, 1.0].
    public let confidenceThreshold: VNConfidence
    
    /// The threshold deciding on when two overlapping objects are considered to be the same.
    public let iouThreshold: Double
    
    /// The minimum TimeInterval in seconds between two ObjectDetection requests. Bounding boxes of detected objects can be updated using object tracking between ObjectDetectionrequests, so that the user experience is smooth even when using bigger TimeIntervals. Setting this value to 0 will run ObjectDetection requests as fast-paced as possible.
    public let objectDetectionRate: TimeInterval
    
    /// A Boolean value indicating whether the bounding box of detected objects should be updated using ObjectTracking between object detection cycles.
    public let objectTrackingEnabled: Bool
    
    /// The minimum confidence value every tracked object needs to match, normalized to [0, 1.0].
    public let objectTrackingConfidenceThreshold: VNConfidence
    
    /// The AVLayerVideoGravity used for the CameraStream Preview. This parameter controls, how the CameraStream Preview is displayed in CameraStreamView.
    public let previewVideoGravity: AVLayerVideoGravity
    
    /// The MLComputeUnits on which the ObjectDetection runs on.
    public let computeUnits: MLComputeUnits
    
    /// A Boolean value indicating whether the distance of every DetectedObject should be calculated.
    public let distanceRecordingEnabled: Bool
    
    /// A list containing all class labels that should be detected (and are supported by the provided CoreML model). If nil, all labels will be detected and no filtering will be applied.
    public let detectableClassLabels: [String]?
    
    /**
     Returns an ``ObjectDetectionServiceConfiguration`` which you can then pass in the init function of ``ObjectDetectionService`` to customize SBB ML to your needs.
     
     - Parameters:
        - confidenceThreshold: The minimum confidence value every detected object needs to match, normalized to [0, 1.0].
        - iouThreshold: The threshold deciding on when two overlapping objects are considered to be the same.
        - objectDetectionRate: The minimum TimeInterval in seconds between two ObjectDetection requests. Bounding boxes of detected objects can be updated using object tracking between ObjectDetectionrequests, so that the user experience is smooth even when using bigger TimeIntervals. Setting this value to 0 will run ObjectDetection requests as fast-paced as possible.
        - objectTrackingConfidenceThreshold: The minimum confidence value every tracked object needs to match, normalized to [0, 1.0].
        - previewVideoGravity: The AVLayerVideoGravity to be used for the CameraStream Preview. This parameter will modify, how the CameraStream Preview is displayed in CameraStreamView.
        - computeUnits: The MLComputeUnits on which the ObjectDetection will run on.
        - distanceRecordingEnabled: A Boolean value indicating whether the distance of every DetectedObject should be calculated. Note that not every device does support this (at least 2 back-facing cameras are required). Might delay object detection by almost 1 second.
        - detectableClassLabels: A list containing all class labels that should be detected (and are supported by the provided CoreML model). If nil, all labels will be detected and no filtering will be applied.
     */
    public init(confidenceThreshold: VNConfidence = 0.5, iouThreshold: Double = 0.6, objectDetectionRate: TimeInterval = 0.0, objectTrackingEnabled: Bool = false, objectTrackingConfidenceThreshold: VNConfidence = 0.3, previewVideoGravity: AVLayerVideoGravity = .resizeAspectFill, computeUnits: MLComputeUnits = .all, distanceRecordingEnabled: Bool = false, detectableClassLabels: [String]? = nil) {
        self.confidenceThreshold = confidenceThreshold
        self.iouThreshold = iouThreshold
        self.objectDetectionRate = objectDetectionRate
        self.objectTrackingEnabled = objectTrackingEnabled
        self.objectTrackingConfidenceThreshold = objectTrackingConfidenceThreshold
        self.previewVideoGravity = previewVideoGravity
        self.computeUnits = computeUnits
        self.distanceRecordingEnabled = distanceRecordingEnabled
        self.detectableClassLabels = detectableClassLabels
    }
}
