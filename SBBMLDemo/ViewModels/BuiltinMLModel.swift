//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import Foundation

enum BuiltinMLModel: String, CaseIterable {
    case int8 = "yolov5-coreML_640_int8"
    case float16 = "yolov5-coreML_640_float16"
    case float32 = "yolov5-coreML_640_float32"
    
    var description: String {
        switch self {
        case .int8:
            return "YOLOv5 CoreML 640 int8"
        case .float16:
            return "YOLOv5 CoreML 640 float16"
        case .float32:
            return "YOLOv5 CoreML 640 float32"
        }
    }
}
