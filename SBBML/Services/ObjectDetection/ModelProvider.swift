//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import Foundation
import Vision

class ModelProvider {
    
    private let modelFileName: String
    private let computeUnits: MLComputeUnits
    
    init(modelFileName: String, computeUnits: MLComputeUnits = .all) {
        self.modelFileName = modelFileName
        self.computeUnits = computeUnits
    }

    func getModel() throws -> VNCoreMLModel {
        guard let modelURL = Bundle.main.url(forResource: modelFileName, withExtension: "mlmodelc") else {
            Logger.log("Model file not found for modelFileName: \(modelFileName), with extension: mlmodelc.", .error)
            throw ObjectDetectionError.cannotLoadModel
        }
        
        let configuration = MLModelConfiguration()
        configuration.computeUnits = computeUnits

        let model = try VNCoreMLModel(for: MLModel(contentsOf: modelURL, configuration: configuration))
        
        return model
    }
}
