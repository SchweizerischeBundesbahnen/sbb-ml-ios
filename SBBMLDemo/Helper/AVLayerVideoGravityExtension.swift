//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import AVFoundation

extension AVLayerVideoGravity {
    var description: String {
        switch self {
        case .resizeAspect:
            return "Resize Aspect"
        case .resizeAspectFill:
            return "Resize Aspect Fill"
        case .resize:
            return "Resize"
        default:
            return "unknown"
        }
    }
}
