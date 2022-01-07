//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import UIKit

extension CGImagePropertyOrientation {
    
    var uiImageOrientation: UIImage.Orientation {
        switch self {
        case .up:
            return .up
        case .upMirrored:
            return .upMirrored
        case .down:
            return .down
        case .downMirrored:
            return .downMirrored
        case .leftMirrored:
            return .leftMirrored
        case .right:
            return .right
        case .rightMirrored:
            return .rightMirrored
        case .left:
            return .left
        }
    }
}
