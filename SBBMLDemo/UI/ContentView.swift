//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import SwiftUI
import SBBDesignSystemMobileSwiftUI
import SBBML

struct ContentView: View {
    
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @ObservedObject var detectedObjectsViewModel = DetectedObjectsViewModel()
    
    var body: some View {
        ZStack {
            if onboardingViewModel.onboardingState != .hidden {
                OnboardingView()
            } else {
                NavigationView {
                    Group {
                        ObjectDetectionView(detectedObjectsViewModel: detectedObjectsViewModel)
                    }
                    .sbbStyle()
                    .navigationBarTitle("SBB ML", displayMode: .inline)
                }
                    .navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
