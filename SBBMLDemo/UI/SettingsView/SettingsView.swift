//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import SwiftUI
import SBBDesignSystemMobileSwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @ObservedObject var detectedObjectsViewModel: DetectedObjectsViewModel
    @Binding var showingModalView: Bool
    
    @State var showComputeUnitsSettingsView = false
    @State var showMLModelSettingsView = false
    @State var showCameraPreviewSettingsView = false

    var body: some View {
        SBBModalView(title: Text("Settings"), titleAlignment: .center, isPresented: $showingModalView, showBackButton: showComputeUnitsSettingsView || showMLModelSettingsView || showCameraPreviewSettingsView, actionOnBackButtonTouched: {
            showComputeUnitsSettingsView = false
            showMLModelSettingsView = false
            showCameraPreviewSettingsView = false
        }) {
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        SBBFormGroup(title: "Camera Preview") {
                            NavigationLink(destination: CameraPreviewSettingsView(detectedObjectsViewModel: detectedObjectsViewModel), isActive: $showCameraPreviewSettingsView, label: { SBBListItem(label: Text("Aspect Ratio"), footnote: Text(detectedObjectsViewModel.previewVideoGravity.description), showBottomLine: false) })
                        }
                        
                        SBBFormGroup(title: "Object Detection") {
                            NavigationLink(destination: ComputeUnitsSettingsView(detectedObjectsViewModel: detectedObjectsViewModel), isActive: $showComputeUnitsSettingsView, label: { SBBListItem(label: Text("Compute Units"), footnote: Text(detectedObjectsViewModel.computeUnits.description), showBottomLine: false) })
                            SBBDivider()
                                .padding(.leading, 16)
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    Text("Confidence Threshold")
                                    Spacer()
                                    Text("\(Int(detectedObjectsViewModel.confidenceThreshold * 100))%")
                                }
                                Slider(value: $detectedObjectsViewModel.confidenceThreshold, in: 0.1...1.0, step: 0.1)
                                    .accentColor(Color.sbbColor(.red))
                            }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                            SBBDivider()
                                .padding(.leading, 16)
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    Text("IOU Threshold")
                                    Spacer()
                                    Text("\(Int(detectedObjectsViewModel.iouThreshold * 100))%")
                                }
                                Slider(value: $detectedObjectsViewModel.iouThreshold, in: 0.1...1.0, step: 0.1)
                                    .accentColor(Color.sbbColor(.red))
                            }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                            SBBDivider()
                                .padding(.leading, 16)
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    Text("Object Detection Rate")
                                    Spacer()
                                    Text("\(String(format: "%.1f", detectedObjectsViewModel.objectDetectionRate))s")
                                }
                                Slider(value: $detectedObjectsViewModel.objectDetectionRate, in: 0.0...2.0, step: 0.1)
                                    .accentColor(Color.sbbColor(.red))
                            }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                            SBBDivider()
                                .padding(.leading, 16)
                            NavigationLink(destination: MLModelSettingsView(detectedObjectsViewModel: detectedObjectsViewModel), isActive: $showMLModelSettingsView, label: { SBBListItem(label: Text("ML Model size"), footnote: Text(detectedObjectsViewModel.model.description), showBottomLine: false) })
                        }
                        
                        SBBFormGroup(title: "Object Tracking") {
                            VStack(alignment: .leading, spacing: 0) {
                                Toggle(isOn: $detectedObjectsViewModel.objectTrackingEnabled) {
                                    Text("Use Object Tracking")
                                }
                                    .toggleStyle(SBBSwitchStyle())
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 16)
                                if detectedObjectsViewModel.objectTrackingEnabled {
                                    SBBDivider()
                                        .padding(.leading, 16)
                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack {
                                            Text("Confidence Threshold")
                                            Spacer()
                                            Text("\(Int(detectedObjectsViewModel.objectTrackingConfidenceThreshold * 100))%")
                                        }
                                        Slider(value: $detectedObjectsViewModel.objectTrackingConfidenceThreshold, in: 0.1...1.0, step: 0.1)
                                            .accentColor(Color.sbbColor(.red))
                                    }
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 16)
                                }
                            }
                        }
                        
                        SBBFormGroup(title: "Object Distance") {
                                Toggle(isOn: $detectedObjectsViewModel.distanceRecordingEnabled) {
                                    Text("Measure distance")
                                }
                                .toggleStyle(SBBSwitchStyle())
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                        }
                        
                        SBBFormGroup(title: "Additional Information") {
                            Button(action: {
                                guard let url = URL(string: "https://code.sbb.ch/projects/KD_ESTA_MOBILE/repos/esta-mobile-ios-ml/browse"),
                                    UIApplication.shared.canOpenURL(url) else {
                                    return
                                }
                                UIApplication.shared.open(url)
                            }) {
                                SBBListItem(label: Text("Official Documentation"), image: Image(sbbName: "document-text", size: .small))
                            }
                            Button(action: {
                                guard let url = URL(string: "https://sbb.sharepoint.com/sites/app-bakery/SitePages/Mobile-Libraries.aspx"),
                                    UIApplication.shared.canOpenURL(url) else {
                                    return
                                }
                                UIApplication.shared.open(url)
                            }) {
                                SBBListItem(label: Text("Mobile Libraries"), image: Image(sbbName: "smartphone", size: .small))
                            }
                            Button(action: {
                                onboardingViewModel.currentOnboardingCardIndex = 0
                                onboardingViewModel.onboardingState = .startView
                                showingModalView = false
                            }) {
                                SBBListItem(label: Text("Show Onboarding"), image: Image(sbbName: "circle-information", size: .small), showBottomLine: false)
                            }
                        }
                    }
                    .sbbScreenPadding()
                }
                    .navigationBarHidden(true)
                    .background(Color.sbbColor(.modalBackground).edgesIgnoringSafeArea(.bottom))
            }
        }
            .sbbStyle()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(detectedObjectsViewModel: DetectedObjectsViewModel(), showingModalView: .constant(true))
    }
}
