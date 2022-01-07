//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import Combine
import Foundation

class InferencePerformanceAnalysis: InferencePerformanceAnalysisProtocol {
   
    var currentInferenceTimePublisher: AnyPublisher<TimeInterval, Never> {
        currentInferenceTimeSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    private let currentInferenceTimeSubject = CurrentValueSubject<TimeInterval, Never>(0)
    
    func updateInferencePerformance(with measurement: TimeInterval) {
        currentInferenceTimeSubject.send(measurement)
    }
}
