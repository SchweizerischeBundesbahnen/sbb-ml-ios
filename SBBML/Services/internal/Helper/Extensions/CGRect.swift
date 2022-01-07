//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import CoreGraphics
import UIKit

extension CGRect {
    
    enum FlipAxis {
        case horizontal
        case vertical
        case none
    }
    
    func convertForCurrentDeviceOrientation() -> CGRect {
        let currentDeviceOrientation = UIDevice.current.orientation
        let rotatedFrame = self.rotate(by: currentDeviceOrientation.rotationForBoundingboxToFrame, around: CGPoint(x: 0.5, y: 0.5))
        let flippedFrame = rotatedFrame.flip(around: currentDeviceOrientation.flipAxisForBoundingboxToFrame)
        return flippedFrame
    }
    
    private func flip(around axis: FlipAxis) -> CGRect {
        switch axis {
        case .none:
            return self
        case .vertical:
            return CGRect(x: self.minX, y: 1 - self.minY - self.height, width: self.width, height: self.height)
        case .horizontal:
            return CGRect(x: 1 - self.minX - self.width, y: self.minY, width: self.width, height: self.height)
        }
    }
    
    private func rotate(by radians: CGFloat, around rotationCenter: CGPoint) -> CGRect {
        let transform = CGAffineTransform(translationX: rotationCenter.x, y: rotationCenter.y)
            .rotated(by: radians)
            .translatedBy(x: -rotationCenter.x, y: -rotationCenter.y)
        
        return self.applying(transform)
    }
}
