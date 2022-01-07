//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import XCTest
import AVFoundation
@testable import SBBML

class ObjectDetectionTests: XCTestCase {
    
    private let timeout = TimeInterval(3.0)
    private var objectDetection: ObjectDetection!

    override func setUpWithError() throws {
        let modelProvider = ModelProvider(modelFileName: "yolov5-coreML_640_int8")
        let thresholdProvider = ThresholdProvider(confidenceThreshold: 0.5, iouThreshold: 0.6)
        
        self.objectDetection = ObjectDetection(modelProvider: modelProvider, thresholdProvider: thresholdProvider, inferencePerformanceAnalysis: nil, depthRecognition: nil)
        objectDetection.previewLayer = AVCaptureVideoPreviewLayer()
    }

    func testDetectObjectsDetectsMainObjects() throws {
        let expectation = self.expectation(description: "wait for detection")

        let image = UIImage(named: "Sitz_1Klasse", in: Bundle(for: ObjectDetectionTests.self), compatibleWith: nil)!
        let cmSampleBuffer = CMSampleBufferCreator.cmSampleBuffer(from: image)
        
        let sub = objectDetection.detectedObjectsPublisher
            .sink(receiveValue: { detectedObjects in
                if detectedObjects.isEmpty {
                    return
                }
                
                XCTAssertTrue(detectedObjects.contains { $0.label == "Sitz"})
                XCTAssertTrue(detectedObjects.contains { $0.label == "Fenster-und-Rahmen"})
                XCTAssertTrue(detectedObjects.contains { $0.label == "Armlehne"})

                expectation.fulfill()
            })

        objectDetection.detectObjects(in: cmSampleBuffer, depthBuffer: nil)
        
        waitForExpectations(timeout: timeout) { _ in
            sub.cancel()
        }
    }
    
    func testDetectObjectsRotatesAndFlipsBoundingBoxCorrectly() throws {
        let expectation = self.expectation(description: "wait for detection")

        let image = UIImage(named: "Sitz_1Klasse", in: Bundle(for: ObjectDetectionTests.self), compatibleWith: nil)!
        let cmSampleBuffer = CMSampleBufferCreator.cmSampleBuffer(from: image)
        
        let sub = objectDetection.detectedObjectsPublisher
            .sink(receiveValue: { detectedObjects in
                guard let detectedObject = detectedObjects.first else {
                    return
                }

                XCTAssertEqual(detectedObject.label, "Sitz")
                XCTAssertTrue(detectedObject.rectInPreviewLayer.minX > 0.1 && detectedObject.rectInPreviewLayer.minX < 0.2)
                XCTAssertTrue(detectedObject.rectInPreviewLayer.minY > 0.1 && detectedObject.rectInPreviewLayer.minY < 0.2)
                XCTAssertTrue(detectedObject.rectInPreviewLayer.maxX > 0.5 && detectedObject.rectInPreviewLayer.maxX < 0.6)
                XCTAssertTrue(detectedObject.rectInPreviewLayer.maxY > 0.8 && detectedObject.rectInPreviewLayer.maxY < 0.9)

                expectation.fulfill()
            })

        objectDetection.detectObjects(in: cmSampleBuffer, depthBuffer: nil)
        
        waitForExpectations(timeout: timeout) { _ in
            sub.cancel()
        }
    }
    
    func testCallingStopIgnoresAllFutureDetectObjectCalls() throws {
        let expectation = self.expectation(description: "wait for detection")

        let image = UIImage(named: "Sitz_1Klasse", in: Bundle(for: ObjectDetectionTests.self), compatibleWith: nil)!
        let cmSampleBuffer = CMSampleBufferCreator.cmSampleBuffer(from: image)
        
        let sub = objectDetection.detectedObjectsPublisher
            .sink(receiveValue: { detectedObjects in
                if !detectedObjects.isEmpty {
                    XCTFail()
                }
            })

        
        objectDetection.stop()
        for _ in 1...5 {
            objectDetection.detectObjects(in: cmSampleBuffer, depthBuffer: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout) { _ in
            sub.cancel()
        }
    }
}
