//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import Foundation
import CoreML

class ThresholdProvider: MLFeatureProvider {
    
    open var values: [String : MLFeatureValue]
    
    init(confidenceThreshold: Double, iouThreshold: Double, new: Bool) {
        if new {
            self.values = [
                "iou threshold": MLFeatureValue(double: iouThreshold),
                "conf threshold": MLFeatureValue(double: confidenceThreshold)
            ]
        } else {
            let iou = try! MLMultiArray(shape: [1], dataType: .double)
            iou[0] = iouThreshold as NSNumber
            let conf = try! MLMultiArray(shape: [1], dataType: .double)
            conf[0] = confidenceThreshold as NSNumber
            self.values = [
                "iouThreshold": MLFeatureValue(multiArray: iou),
                "confidenceThreshold": MLFeatureValue(multiArray: conf)
            ]
        }
    }
    
    var featureNames: Set<String> {
        return Set(values.keys)
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return values[featureName]
    }

}
