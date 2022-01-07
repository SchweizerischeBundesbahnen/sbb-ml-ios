//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import AVFoundation
import Accelerate

class DepthRecognition: DepthRecognitionProtocol {
    
    func getDepth(of point: CGPoint, in depthBuffer: CVPixelBuffer) -> Float {

        let width = CGFloat(CVPixelBufferGetWidth(depthBuffer))
        let height = CGFloat(CVPixelBufferGetHeight(depthBuffer))
        CVPixelBufferLockBaseAddress(depthBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        let x = point.x * width
        let y = point.y * height
        let depthPoint = CGPoint(x: x, y: y)
        
        CVPixelBufferLockBaseAddress(depthBuffer, .readOnly)
        let rowData = CVPixelBufferGetBaseAddress(depthBuffer)! + Int(depthPoint.y) * CVPixelBufferGetBytesPerRow(depthBuffer)
        // swift does not have an Float16 data type. Use UInt16 instead, and then translate
        var f16Pixel = rowData.assumingMemoryBound(to: UInt16.self)[Int(depthPoint.x)]
        CVPixelBufferUnlockBaseAddress(depthBuffer, .readOnly)
        
        var f32Pixel = Float(0.0)
        var src = vImage_Buffer(data: &f16Pixel, height: 1, width: 1, rowBytes: 2)
        var dst = vImage_Buffer(data: &f32Pixel, height: 1, width: 1, rowBytes: 4)
        vImageConvert_Planar16FtoPlanarF(&src, &dst, 0)
        
        return 1 / f32Pixel    // depth data is captured in a disparity (not depth) format. distance = 1 / disparity
    }
}
