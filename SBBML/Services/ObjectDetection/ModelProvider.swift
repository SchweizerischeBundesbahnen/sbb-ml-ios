//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import Foundation
import Vision

class ModelProvider {
    
    private let modelFileName: String
    private let computeUnits: MLComputeUnits
    var labels: [String]? = nil
    
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
        
        let mlModel = try MLModel(contentsOf: modelURL, configuration: configuration)
        self.labels = ((mlModel.modelDescription.metadata[MLModelMetadataKey.creatorDefinedKey] as? Dictionary<String, Any>)?["names"] as? String)?.components(separatedBy: ",")

        let model = try VNCoreMLModel(for: mlModel)
        
        return model
    }
}
