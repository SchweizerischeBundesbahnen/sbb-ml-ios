//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import Foundation
import CoreML

class ThresholdProvider: MLFeatureProvider {
    
    open var values: [String : MLFeatureValue]
    
    init(confidenceThreshold: Double, iouThreshold: Double) {
        self.values = [
            "iou threshold": MLFeatureValue(double: iouThreshold),
            "conf threshold": MLFeatureValue(double: confidenceThreshold)
        ]
    }
    
    var featureNames: Set<String> {
        return Set(values.keys)
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return values[featureName]
    }

}
