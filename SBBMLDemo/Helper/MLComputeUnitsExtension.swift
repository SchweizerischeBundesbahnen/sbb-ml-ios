//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import CoreML

extension MLComputeUnits {
    var description: String {
        switch self {
        case .cpuOnly:
            return "CPU only"
        case .cpuAndGPU:
            return "CPU and GPU"
        case .all:
            return "all"
        @unknown default:
            return "unknown"
        }
    }
}
