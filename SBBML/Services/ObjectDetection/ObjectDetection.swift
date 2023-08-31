//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import AVFoundation
import Vision
import UIKit
import Combine
import Accelerate
import CoreML

class ObjectDetection: ObjectDetectionProtocol {
    
    var detectedObjectsPublisher: AnyPublisher<[DetectedObject], Never> {
        detectedObjectsSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    private let detectedObjectsSubject = CurrentValueSubject<[DetectedObject], Never>([DetectedObject]())
    
    var errorPublisher: AnyPublisher<ObjectDetectionError?, Never> {
        errorSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    private let errorSubject = CurrentValueSubject<ObjectDetectionError?, Never>(nil)
    
    var inferencePerformanceAnalysis: InferencePerformanceAnalysisProtocol?
    var depthRecognition: DepthRecognitionProtocol?
    private var requests = [VNRequest]()
    var previewLayer: AVCaptureVideoPreviewLayer?
    private var currentDepthBuffer: CVPixelBuffer?
    var labels: [String]?
        
    init(modelProvider: ModelProvider, thresholdProvider: ThresholdProvider, inferencePerformanceAnalysis: InferencePerformanceAnalysisProtocol?, depthRecognition: DepthRecognitionProtocol?) {
        self.inferencePerformanceAnalysis = inferencePerformanceAnalysis
        self.depthRecognition = depthRecognition
        setupCoreML(modelProvider: modelProvider, thresholdProvider: thresholdProvider)
    }
    
    func detectObjects(in videoBuffer: CMSampleBuffer, depthBuffer: CVPixelBuffer?) {
        do {
            guard let imageBuffer = CMSampleBufferGetImageBuffer(videoBuffer) else {
                throw ObjectDetectionError.cannotCreateImageBuffer
            }
            
            self.currentDepthBuffer = depthBuffer
            let currentDeviceOrientation = UIDevice.current.orientation
            
            /*
            // This code can be used for debugging, to see, how the imageBuffer is oriented (set a breakpoint a check resultImage with QuickLook in the XCode debugger
            let ciImage = CIImage(cvPixelBuffer: imageBuffer)
            let resultImage = UIImage(ciImage: ciImage, scale: 1, orientation: currentDeviceOrientation.exifOrientation.uiImageOrientation)
            */
            
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: imageBuffer, orientation: currentDeviceOrientation.exifOrientation, options: [:])
            do {
                let startTime = Date().timeIntervalSince1970
                try imageRequestHandler.perform(self.requests)
                let endTime = Date().timeIntervalSince1970
                inferencePerformanceAnalysis?.updateInferencePerformance(with: endTime - startTime)
            } catch {
                print(error)
            }
        } catch let error as ObjectDetectionError {
            self.errorSubject.send(error)
        } catch {
            Logger.log("Unknown error while trying to create CMSampleBufferGetImageBuffer: \(error)", .error)
        }
    }
    
    func stop() {
        requests.removeAll()
    }
    
    private func setupCoreML(modelProvider: ModelProvider, thresholdProvider: ThresholdProvider) {
        
        do {
            let visionModel = try modelProvider.getModel()
            self.labels = modelProvider.labels
            visionModel.featureProvider = thresholdProvider

            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                if let objectObservations = request.results as? [VNRecognizedObjectObservation] {
                    self.processDetectedObjects(observations: objectObservations)
                } else if let objectObservations = request.results as? [VNCoreMLFeatureValueObservation] {
                    self.processSegmentedObjects(observations: objectObservations)
                }
                
            })
            objectRecognition.imageCropAndScaleOption = .scaleFit
            self.requests = [objectRecognition]
        } catch let error as NSError {
            Logger.log("Model loading went wrong: \(error)", .error)
        }
    }
    
    private func processDetectedObjects(observations: [VNRecognizedObjectObservation]) {
        guard let previewLayer = previewLayer else {
            Logger.log("ObjectDetection: Cannot process detected objects, because the PreviewLayer is not set.", .error)
            return
        }
        DispatchQueue.main.async { [self] in
            var detectedObjects = [DetectedObject]()
            for observation in observations {
                if let identifier = observation.labels.first?.identifier {
                    //Logger.log("Found \(identifier) ((\(observation.confidence)) in rect: \(observation.boundingBox)", .debug)

                    // convert to rect in screen
                    let convertedBoundingBoxForCurrentDeviceOrientation = observation.boundingBox.convertForCurrentDeviceOrientation()
                    let boundingBoxInPreviewLayer = previewLayer.layerRectConverted(fromMetadataOutputRect: convertedBoundingBoxForCurrentDeviceOrientation)

                    var depth: Float?
                    if let depthBuffer = currentDepthBuffer {
                        depth = depthRecognition?.getDepth(of: CGPoint(x: convertedBoundingBoxForCurrentDeviceOrientation.midX, y: convertedBoundingBoxForCurrentDeviceOrientation.midY), in: depthBuffer)
                    }

                    detectedObjects.append(DetectedObject(label: identifier, confidence: observation.confidence, depth: depth, rect: observation.boundingBox, rectInPreviewLayer: boundingBoxInPreviewLayer))
                }
            }
            self.detectedObjectsSubject.send(detectedObjects)
        }
    }
    
    private func processSegmentedObjects(observations: [VNCoreMLFeatureValueObservation]) {
        guard let previewLayer = previewLayer else {
            Logger.log("ObjectDetection: Cannot process detected objects, because the PreviewLayer is not set.", .error)
            return
        }
        
        
        DispatchQueue.main.async { [self] in
            var detectedObjects = [DetectedObject]()
            
            if let nbDetections = observations.first(where: { $0.featureName == "numberDetections"})?.featureValue.multiArrayValue?[0] as? Int,
               let confidences = observations.first(where: { $0.featureName == "confidence"})?.featureValue.multiArrayValue,
               let coordinates = observations.first(where: { $0.featureName == "coordinates"})?.featureValue.multiArrayValue,
               let masks = observations.first(where: { $0.featureName == "masks"})?.featureValue.multiArrayValue,
               let labels = self.labels {
                for i in 0..<nbDetections {
                    var best_conf: NSNumber = 0
                    var best_index: Int = 0
                    for c in 0..<labels.count {
                        let b: NSNumber = confidences[[0, 0, 0, i as NSNumber, c as NSNumber]]
                        if b.compare(best_conf) == .orderedDescending {
                            best_conf = b
                            best_index = c
                        }
                    }
                    
                    // xywh (x,y center) -> we want bottom left corner ?
                    let x = coordinates[[0, 0, 0, i as NSNumber, 0]] as! CGFloat
                    let y = coordinates[[0, 0, 0, i as NSNumber, 1]] as! CGFloat
                    let w = coordinates[[0, 0, 0, i as NSNumber, 2]] as! CGFloat
                    let h = coordinates[[0, 0, 0, i as NSNumber, 3]] as! CGFloat
                    
                    let bbox = CGRect(x: x - w/2, y: y - h/2, width: w, height: h)
                    let bboxInPreviewLayer = previewLayer.layerRectConverted(fromMetadataOutputRect: bbox.convertForCurrentDeviceOrientation().flip(around: .horizontal))
                                                                    
                    detectedObjects.append(DetectedObject(label: labels[best_index], confidence: best_conf as! Float, depth: nil, rect: bbox, rectInPreviewLayer: bboxInPreviewLayer, masks: masks, maskIndex: i as NSNumber))
                }
                
            }
            self.detectedObjectsSubject.send(detectedObjects)
        }
    }
}
