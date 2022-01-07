//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import SwiftUI
import SBBDesignSystemMobileSwiftUI
import CoreML

struct ComputeUnitsSettingsView: View {
    
    @ObservedObject var detectedObjectsViewModel: DetectedObjectsViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            SBBRadioButtonGroup(title: "Compute Units", selection: $detectedObjectsViewModel.computeUnits, tags: [.all, .cpuAndGPU, .cpuOnly]) {
                SBBRadioButton(text: Text(MLComputeUnits.all.description))
                SBBRadioButton(text: Text(MLComputeUnits.cpuAndGPU.description))
                SBBRadioButton(text: Text(MLComputeUnits.cpuOnly.description), showBottomLine: false)
            }
        }
            .navigationBarHidden(true)
            .sbbScreenPadding()
            .background(Color.sbbColor(.modalBackground).edgesIgnoringSafeArea(.bottom))
            .sbbStyle()
    }
}

struct ComputeUnitsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ComputeUnitsSettingsView(detectedObjectsViewModel: DetectedObjectsViewModel())
    }
}
