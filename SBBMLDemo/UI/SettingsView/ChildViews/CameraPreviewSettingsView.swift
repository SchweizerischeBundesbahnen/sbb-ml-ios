//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import SwiftUI
import SBBDesignSystemMobileSwiftUI
import AVFoundation

struct CameraPreviewSettingsView: View {
    
    @ObservedObject var detectedObjectsViewModel: DetectedObjectsViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            SBBRadioButtonGroup(title: "Camera Preview Aspect Ratio", selection: $detectedObjectsViewModel.previewVideoGravity, tags: [.resizeAspect, .resizeAspectFill, .resize]) {
                SBBRadioButton(text: Text(AVLayerVideoGravity.resizeAspect.description))
                SBBRadioButton(text: Text(AVLayerVideoGravity.resizeAspectFill.description))
                SBBRadioButton(text: Text(AVLayerVideoGravity.resize.description), showBottomLine: false)
            }
        }
            .navigationBarHidden(true)
            .sbbScreenPadding()
            .background(Color.sbbColor(.modalBackground).edgesIgnoringSafeArea(.bottom))
            .sbbStyle()
    }
}

struct CameraPreviewSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CameraPreviewSettingsView(detectedObjectsViewModel: DetectedObjectsViewModel())
    }
}
