//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import AVFoundation

protocol DepthRecognitionProtocol {
    func getDepth(of point: CGPoint, in depthBuffer: CVPixelBuffer) -> Float
}
