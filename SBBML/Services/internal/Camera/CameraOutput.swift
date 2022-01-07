//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//

import AVFoundation

struct CameraOutput {
    
    let videoBuffer: CMSampleBuffer
    let depthBuffer: CVPixelBuffer?
}
