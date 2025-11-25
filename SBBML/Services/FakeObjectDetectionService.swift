//
// Copyright (c) Schweizerische Bundesbahnen SBB, 2025
//

import Foundation
import Combine

public class FakeObjectDetectionService: ObjectDetectionServiceProtocol {

    let detectedObjectsSubject = PassthroughSubject<[DetectedObject], Never>()
    public var detectedObjectsPublisher: AnyPublisher<[DetectedObject], Never> {
        detectedObjectsSubject.eraseToAnyPublisher()
    }
    public var detectedObjectsStream: AsyncStream<[DetectedObject]> {
        AsyncStream { continuation in
            let cancellable = detectedObjectsSubject
                .sink(receiveValue: { value in
                    continuation.yield(value)
                })
            
            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
    }

    let errorSubject = PassthroughSubject<ObjectDetectionError?, Never>()
    public var errorPublisher: AnyPublisher<ObjectDetectionError?, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    public var errorStream: AsyncStream<ObjectDetectionError?> {
        AsyncStream { continuation in
            let cancellable = errorSubject
                .removeDuplicates()
                .sink(receiveValue: { value in
                    continuation.yield(value)
                })
            
            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
    }

    let currentObjectDetectionInferenceTimeSubject = PassthroughSubject<TimeInterval, Never>()
    public var currentObjectDetectionInferenceTimePublisher: AnyPublisher<TimeInterval, Never> {
        currentObjectDetectionInferenceTimeSubject.eraseToAnyPublisher()
    }
    public var currentObjectDetectionInferenceTimeStream: AsyncStream<TimeInterval> {
        AsyncStream { continuation in
            let cancellable = currentObjectDetectionInferenceTimeSubject
                .sink(receiveValue: { value in
                    continuation.yield(value)
                })
            
            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
    }

    public func requestCameraAuthorization() { }
}
