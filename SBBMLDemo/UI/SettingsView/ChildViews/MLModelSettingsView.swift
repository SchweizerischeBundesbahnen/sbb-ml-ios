//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import SwiftUI
import SBBDesignSystemMobileSwiftUI

struct MLModelSettingsView: View {
    
    @ObservedObject var detectedObjectsViewModel: DetectedObjectsViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            SBBRadioButtonGroup(title: "ML Model Size", selection: $detectedObjectsViewModel.model, tags: BuiltinMLModel.allCases) {
                SBBRadioButton(text: Text(BuiltinMLModel.int8.description))
                SBBRadioButton(text: Text(BuiltinMLModel.float16.description), showBottomLine: false)
            }
        }
            .navigationBarHidden(true)
            .sbbScreenPadding()
            .background(Color.sbbColor(.modalBackground).edgesIgnoringSafeArea(.bottom))
            .sbbStyle()
    }
}

struct MLModelSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        MLModelSettingsView(detectedObjectsViewModel: DetectedObjectsViewModel())
    }
}
