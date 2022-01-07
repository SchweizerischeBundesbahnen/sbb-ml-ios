//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import AVFoundation
import ImageIO
import UIKit

// (modified) Conversion code is from: https://gist.github.com/levantAJ/4e3e40ba2fa190fd88e329ede8f27f3f
class CMSampleBufferCreator {
    
    static func cmSampleBuffer(from uiImage: UIImage) -> CMSampleBuffer {
        let pixelBuffer = cvPixelBuffer(from: uiImage)
        var newSampleBuffer: CMSampleBuffer? = nil
        var timimgInfo: CMSampleTimingInfo = CMSampleTimingInfo.invalid
        var videoInfo: CMVideoFormatDescription? = nil
        CMVideoFormatDescriptionCreateForImageBuffer(allocator: nil, imageBuffer: pixelBuffer, formatDescriptionOut: &videoInfo)
        CMSampleBufferCreateForImageBuffer(allocator: kCFAllocatorDefault, imageBuffer: pixelBuffer, dataReady: true, makeDataReadyCallback: nil, refcon: nil, formatDescription: videoInfo!, sampleTiming: &timimgInfo, sampleBufferOut: &newSampleBuffer)
        return newSampleBuffer!
    }
    
    private static func cvPixelBuffer(from uiImage: UIImage) -> CVPixelBuffer {
        var pixelBuffer: CVPixelBuffer? = nil
        let options: [NSObject: Any] = [
            kCVPixelBufferCGImageCompatibilityKey: false,
            kCVPixelBufferCGBitmapContextCompatibilityKey: false,
            ]
        _ = CVPixelBufferCreate(kCFAllocatorDefault, Int(uiImage.size.width), Int(uiImage.size.height), kCVPixelFormatType_32ARGB, options as CFDictionary, &pixelBuffer)
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(uiImage.size.width), height: Int(uiImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        context?.draw(uiImage.cgImage!, in: CGRect(origin: .zero, size: uiImage.size))
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        return pixelBuffer!
    }
}
