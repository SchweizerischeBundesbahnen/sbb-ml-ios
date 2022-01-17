//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import Foundation
import Combine
import SBBML
import AVFoundation
import CoreML
import Vision
import SwiftUI

class DetectedObjectsViewModel: ObservableObject {
    
    @Published var detectedObjects: [DetectedObject]?
    @Published var objectDetectionError: ObjectDetectionError?
    @Published var currentObjectDetectionInferenceTime: TimeInterval = 0

    @Published var confidenceThreshold: Double
    @Published var iouThreshold: Double
    @Published var objectDetectionRate: Double {
        didSet {
            if objectDetectionRate < 0.5 && objectTrackingEnabled {
                objectTrackingEnabled = false
            }
        }
    }
    @Published var objectTrackingEnabled: Bool {
        didSet {
            if objectTrackingEnabled && objectDetectionRate < 0.5 {
                objectDetectionRate = 0.5
            }
        }
    }
    @Published var objectTrackingConfidenceThreshold: Double
    @Published var previewVideoGravity: AVLayerVideoGravity
    @Published var computeUnits: MLComputeUnits
    @Published var distanceRecordingEnabled: Bool
    @Published var model: BuiltinMLModel
    
    var objectDetectionService: ObjectDetectionService
    var objectDetectionServiceConfiguration: ObjectDetectionServiceConfiguration
    
    private var detectedObjectsSubscription: AnyCancellable!
    private var errorSubscription: AnyCancellable!
    private var currentObjectDetectionInferenceTimeSubscription: AnyCancellable!
    
    private var labelColors = [String: Color]()
    private let sbbColors = [Color.sbbColor(.red), Color.sbbColor(.blue), Color.sbbColor(.autumn), Color.sbbColor(.sky), Color.sbbColor(.peach), Color.sbbColor(.green), Color.sbbColor(.night), Color.sbbColor(.orange), Color.sbbColor(.lemon)]
    
    init() {
        let objectDetectionServiceConfiguration = ObjectDetectionServiceConfiguration()
        let model = BuiltinMLModel.wagenN640Int8
        self.model = model
        self.confidenceThreshold = Double(objectDetectionServiceConfiguration.confidenceThreshold)
        self.iouThreshold = objectDetectionServiceConfiguration.iouThreshold
        self.objectDetectionRate = objectDetectionServiceConfiguration.objectDetectionRate
        self.objectTrackingEnabled = objectDetectionServiceConfiguration.objectTrackingEnabled
        self.objectTrackingConfidenceThreshold = Double(objectDetectionServiceConfiguration.objectTrackingConfidenceThreshold)
        self.previewVideoGravity = objectDetectionServiceConfiguration.previewVideoGravity
        self.computeUnits = objectDetectionServiceConfiguration.computeUnits
        self.distanceRecordingEnabled = false
        self.objectDetectionServiceConfiguration = objectDetectionServiceConfiguration
        self.objectDetectionService = ObjectDetectionService(modelFileName: model.rawValue, configuration: objectDetectionServiceConfiguration)
        
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        errorSubscription = objectDetectionService.errorPublisher
            .sink(receiveValue: { [weak self] objectDetectionError in
                self?.objectDetectionError = objectDetectionError
            })
        
        detectedObjectsSubscription = objectDetectionService.detectedObjectsPublisher
            .sink(receiveValue: { [weak self] detectedObjects in
                self?.detectedObjects = detectedObjects
            })
        
        currentObjectDetectionInferenceTimeSubscription = objectDetectionService.currentObjectDetectionInferenceTimePublisher
            .sink(receiveValue: { [weak self] inferenceTime in
                self?.currentObjectDetectionInferenceTime = inferenceTime
            })
    }
    
    func configureObjectDetectionService() {
        let objectDetectionServiceConfiguration = ObjectDetectionServiceConfiguration(confidenceThreshold: VNConfidence(confidenceThreshold), iouThreshold: iouThreshold, objectDetectionRate: objectDetectionRate, objectTrackingEnabled: objectTrackingEnabled, objectTrackingConfidenceThreshold: VNConfidence(objectTrackingConfidenceThreshold), previewVideoGravity: previewVideoGravity, computeUnits: computeUnits, distanceRecordingEnabled: distanceRecordingEnabled)
        self.objectDetectionServiceConfiguration = objectDetectionServiceConfiguration
        self.objectDetectionService = ObjectDetectionService(modelFileName: model.rawValue, configuration: objectDetectionServiceConfiguration)
        setupSubscriptions()
        self.objectDetectionService.requestCameraAuthorization()
    }
    
    func color(for label: String) -> Color {
        if let color = labelColors[label] {
            return color
        }
        
        var randomColor = Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), opacity: 1)
        if labelColors.count < sbbColors.count {
            randomColor = sbbColors[labelColors.count]
        }
        labelColors[label] = randomColor
        
        return randomColor
    }
}
