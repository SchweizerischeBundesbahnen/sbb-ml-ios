//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import Combine
import Foundation

protocol InferencePerformanceAnalysisProtocol {
    var currentInferenceTimePublisher: AnyPublisher<TimeInterval, Never> { get }
    func updateInferencePerformance(with measurement: TimeInterval)
}
