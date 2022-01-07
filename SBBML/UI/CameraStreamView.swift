//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import SwiftUI

/// A View that shows the live CameraStream which is also processed for ObjectDetection. To use SBB ML, this View needs to be added to your SwiftUI View tree. Typically you would then use an .overlay ViewModifier to draw the BoundingBoxes of the published detected objects over the his View.
public struct CameraStreamView: View {
    
    let objectDetectionService: ObjectDetectionService
    
    /**
     Returns a CameraStreamView showing the live CameraStream which is also processed for ObjectDetection.
     
     - Parameters:
        - objectDetectionService: The ``ObjectDetectionService`` who controls the camera and ObjectDetection.
     */
    public init(objectDetectionService: ObjectDetectionService) {
        self.objectDetectionService = objectDetectionService
    }
    
    public var body: some View {
        CameraStreamViewControllerRepresentation(objectDetectionService: objectDetectionService)
    }
}

struct CameraStreamView_Previews: PreviewProvider {
    static var previews: some View {
        CameraStreamView(objectDetectionService: ObjectDetectionService(modelFileName: "name"))
    }
}
