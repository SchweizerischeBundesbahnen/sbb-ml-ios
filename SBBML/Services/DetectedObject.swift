//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import Foundation
import UIKit
import AVFoundation

/// An Object containing information about a detected object while running the ObjectDetection algorithm from camera input.
public struct DetectedObject: Equatable, Identifiable {
    
    /// UUID strings, to uniquely identify this DetectedObject.
    public let id = UUID()
    
    /// The class label of the detected object (according to the used CoreML model).
    public let label: String
    
    /// The confidence of the prediction ranging from 0 to 1.
    public let confidence: Float
    
    /// The approximate distance of the device to the center of the detected object. This parameter is only set when running DepthData (can be configured using ObjectDetectionServiceConfiguration).
    public let depth: Float? // in m
    
    /// The normalized bounding box of the detected object. (0,0) is the bottom left corner.
    public var rect: CGRect
    
    /// The bounding box relative to the PreviewLayer of ``CameraStreamView``.
    public var rectInPreviewLayer: CGRect
    
    /**
     Returns a ``DetectedObject`` which you can use to create fake objects e.g. for SwiftuI Previews, Testing etc.
     
     - Parameters:
        - label: The class label of the detected object (according to the used CoreML model).
        - confidence: The confidence of the prediction ranging from 0 to 1.
        - depth: The approximate distance of the device to the center of the detected object. This parameter is only set when running DepthData (can be configured using ObjectDetectionServiceConfiguration).
        - rect: The normalized bounding box of the detected object. (0,0) is the bottom left corner.
        - rectInPreviewLayer: The bounding box relative to the PreviewLayer of ``CameraStreamView``.
     */
    public init(label: String, confidence: Float, depth: Float?, rect: CGRect, rectInPreviewLayer: CGRect) {
        self.label = label
        self.confidence = confidence
        self.depth = depth
        self.rect = rect
        self.rectInPreviewLayer = rectInPreviewLayer
    }
}
