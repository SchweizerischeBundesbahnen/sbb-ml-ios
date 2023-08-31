//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//

import SwiftUI
import SBBDesignSystemMobileSwiftUI
import SBBML

struct BoundingBoxesView: View {
    
    @ObservedObject var detectedObjectsViewModel: DetectedObjectsViewModel
    
    var body: some View {
        GeometryReader { geometry in
            if !(detectedObjectsViewModel.detectedObjects?.isEmpty ?? true) {
                ForEach(detectedObjectsViewModel.detectedObjects!) { detectedObject in
                    ZStack(alignment: .topLeading) {
                        
                        if detectedObject.masks != nil {
                            // Draw mask
                            if #available(iOS 15.0, *) {
                                Canvas { context, size in
                                    drawMask(on: context, canvasSize: size, detectedObject: detectedObject)
                                }
                                .frame(width: geometry.size.height, height: geometry.size.height)
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                        Rectangle()
                            .strokeBorder(detectedObjectsViewModel.color(for: detectedObject.label), lineWidth: 4)
                            .frame(width: detectedObject.rectInPreviewLayer.width, height: detectedObject.rectInPreviewLayer.height)
                            .position(x: detectedObject.rectInPreviewLayer.midX, y: detectedObject.rectInPreviewLayer.midY)
                        Text(text(for: detectedObject))
                            .foregroundColor(Color.white)
                            .background(detectedObjectsViewModel.color(for: detectedObject.label))
                            .offset(x: detectedObject.rectInPreviewLayer.minX, y: detectedObject.rectInPreviewLayer.minY)
                    }
                }
            }
        }
    }
    
    @available(iOS 15.0, *)
    private func drawMask(on context: GraphicsContext, canvasSize: CGSize, detectedObject: DetectedObject) {
        if let mask = detectedObject.masks, let maskIndex = detectedObject.maskIndex {
            let maskWidth = mask.shape[3].intValue
            let maskHeight = mask.shape[4].intValue
            let w = canvasSize.width / CGFloat(maskWidth)
            let h = canvasSize.height / CGFloat(maskHeight)
                        
            for i in 0..<maskWidth {
                for j in 0..<maskHeight {
                    let value = mask[[0, 0, maskIndex, j as NSNumber, i as NSNumber]].int32Value
                    
                    let iw = i - 80
                    if value != 0 && iw > 0 && iw < 240 {
                        context.fill(
                            Path(CGRect(x: CGFloat(iw) * w, y: CGFloat(j) * h, width: w, height: h)),
                            with: .color(detectedObjectsViewModel.color(for: detectedObject.label)))
                    }
                }
            }
        }
    }
    
    func text(for detectedObject: DetectedObject) -> String {
        var text = "\(detectedObject.label) (\(String(format: "%.2f", detectedObject.confidence)))"
        if let depth = detectedObject.depth {
            text.append("\n\(String(format: "%.2f", depth))m")
        }
        return text
    }
}

struct DetectedObjectsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BoundingBoxesView(detectedObjectsViewModel: DetectedObjectsViewModel())
                .previewDisplayName("Light")
            BoundingBoxesView(detectedObjectsViewModel: DetectedObjectsViewModel())
                .previewDisplayName("Dark")
                .environment(\.colorScheme, .dark)
        }
    }
}
