//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import UIKit

extension UIDeviceOrientation {
    
    var exifOrientation: CGImagePropertyOrientation {
        switch self {
        case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
            return .left
        case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
            return .upMirrored
        case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
            return .down
        case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
            return .right
        default:
            return .right
        }
    }
    
    var rotationForBoundingboxToFrame: CGFloat {
        switch self {
        case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
            return 0
        case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
            return .pi
        case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
            return 0
        case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
            return .pi / 2
        default:
            return .pi / 2
        }
    }
    
    var flipAxisForBoundingboxToFrame: CGRect.FlipAxis {
        switch self {
        case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
            return .none
        case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
            return .none
        case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
            return .horizontal
        case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
            return .vertical
        default:
            return .vertical
        }
    }
}
