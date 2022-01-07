//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import SwiftUI

struct CameraStreamViewControllerRepresentation: UIViewControllerRepresentable {
    let objectDetectionService: ObjectDetectionService

    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraStreamViewControllerRepresentation>) -> CameraStreamViewController {
        return CameraStreamViewController(objectDetectionService: objectDetectionService)
    }

    func updateUIViewController(_ uiViewController: CameraStreamViewController, context: UIViewControllerRepresentableContext<CameraStreamViewControllerRepresentation>) {
        if uiViewController.objectDetectionService.configuration != objectDetectionService.configuration || uiViewController.objectDetectionService.modelFileName != objectDetectionService.modelFileName {
            uiViewController.removePreviewLayer()
            uiViewController.objectDetectionService = objectDetectionService
            uiViewController.addPreviewLayer()
        }
    }
}

