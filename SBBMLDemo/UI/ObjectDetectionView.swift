//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import SwiftUI
import SBBML
import SBBDesignSystemMobileSwiftUI

struct ObjectDetectionView: View {
    
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @ObservedObject var detectedObjectsViewModel: DetectedObjectsViewModel
    @State var showingModalView = false
    
    var body: some View {
        Group {
            if let error = detectedObjectsViewModel.objectDetectionError {
                ErrorView(error: error)
            } else {
                ZStack(alignment: .bottomTrailing) {
                    CameraStreamView(objectDetectionService: detectedObjectsViewModel.objectDetectionService)
                        .overlay(
                            ZStack {
                                BoundingBoxesView(detectedObjectsViewModel: detectedObjectsViewModel)
                            }
                        )
                        .edgesIgnoringSafeArea([.bottom, .horizontal])
                    VStack(alignment: .trailing) {
                        if let detectedObjects = detectedObjectsViewModel.detectedObjects, detectedObjects.isEmpty {
                            SBBInfoView(image: Image(sbbName: "camera", size: .medium), text: Text("Please point your camera to SBB objects."))
                        } else {
                            SBBInfoView(image: Image(sbbName: "chart-column-trend", size: .medium), text: Text("Inference Time: \n\(String(format: "%.3f", detectedObjectsViewModel.currentObjectDetectionInferenceTime))s"))
                        }
                        Spacer()
                        Button(action: {
                            showingModalView = true
                        }) {
                            HStack {
                                Image(sbbName: "controls", size: .small)
                                Text("Settings")
                            }
                        }
                            .buttonStyle(SBBPrimaryButtonStyle(sizeToFit: true))
                    }
                        .sbbScreenPadding()
                }
            }
        }
        .sheet(isPresented: $showingModalView, onDismiss: {
            DispatchQueue.main.async {
                detectedObjectsViewModel.configureObjectDetectionService()
            }
        }) {
            SettingsView(detectedObjectsViewModel: detectedObjectsViewModel, showingModalView: $showingModalView)
                .environmentObject(onboardingViewModel)
        }
    }
}

struct ObjectDetectionView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectDetectionView(detectedObjectsViewModel: DetectedObjectsViewModel())
    }
}
