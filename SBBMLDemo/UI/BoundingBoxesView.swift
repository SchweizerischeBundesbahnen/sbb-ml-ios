//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//

import SwiftUI
import SBBDesignSystemMobileSwiftUI
import SBBML

struct BoundingBoxesView: View {
    
    @ObservedObject var detectedObjectsViewModel: DetectedObjectsViewModel
    
    var body: some View {
        if !(detectedObjectsViewModel.detectedObjects?.isEmpty ?? true) {
            ForEach(detectedObjectsViewModel.detectedObjects!) { detectedObject in
                ZStack(alignment: .topLeading) {
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
