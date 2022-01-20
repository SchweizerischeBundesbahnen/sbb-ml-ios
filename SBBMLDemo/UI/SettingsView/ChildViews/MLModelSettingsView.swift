//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import SwiftUI
import SBBDesignSystemMobileSwiftUI

struct MLModelSettingsView: View {
    
    @ObservedObject var detectedObjectsViewModel: DetectedObjectsViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            SBBRadioButtonGroup(title: "ML Model", selection: $detectedObjectsViewModel.model, tags: Array(BuiltinMLModel.allCases)) {
                SBBRadioButton(text: Text(BuiltinMLModel.bahnhofM640Int8.description))
                SBBRadioButton(text: Text(BuiltinMLModel.bahnhofM640Float16.description))
                SBBRadioButton(text: Text(BuiltinMLModel.bahnhofM640Float32.description))
                SBBRadioButton(text: Text(BuiltinMLModel.bahnhofS640Int8.description))
                SBBRadioButton(text: Text(BuiltinMLModel.bahnhofS640Float16.description))
                SBBRadioButton(text: Text(BuiltinMLModel.bahnhofS640Float32.description))
                SBBRadioButton(text: Text(BuiltinMLModel.wagenM640Int8.description))
                SBBRadioButton(text: Text(BuiltinMLModel.wagenM640Float16.description))
                SBBRadioButton(text: Text(BuiltinMLModel.wagenM640Float32.description))
                SBBRadioButton(text: Text(BuiltinMLModel.wagenN640Int8.description))
                SBBRadioButton(text: Text(BuiltinMLModel.wagenN640Float16.description))
                SBBRadioButton(text: Text(BuiltinMLModel.wagenN640Float32.description))
                SBBRadioButton(text: Text(BuiltinMLModel.universalM640Int8.description))
                SBBRadioButton(text: Text(BuiltinMLModel.universalM640Float16.description))
                SBBRadioButton(text: Text(BuiltinMLModel.universalM640Float32.description), showBottomLine: false)
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
