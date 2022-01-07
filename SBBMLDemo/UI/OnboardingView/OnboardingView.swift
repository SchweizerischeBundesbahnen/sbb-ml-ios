//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import SwiftUI
import SBBDesignSystemMobileSwiftUI

struct OnboardingView: View {
    
    @EnvironmentObject var viewModel: OnboardingViewModel
    
    private let startView = SBBOnboardingTitleView(image: Image("Onboarding_Start"), title: Text("Welcome to the SBB ML Demo App"))
    private let endView = SBBOnboardingTitleView(image: Image("Onboarding_Start"), title: Text("Enjoy exploring the capabilites of the MachineLearning library."))

    var body: some View {
        SBBOnboardingView(state: $viewModel.onboardingState, currentCardIndex: $viewModel.currentOnboardingCardIndex, startView: startView, endView: endView) {
            SBBOnboardingCardView(image: Image("Onboarding_Card1"), title: Text("ML Framework"), text: Text("With the SBB ML library, SBB Apps can automatically detect over 100 SBB-specific objects.")) {
                Button(action: {
                    guard let url = URL(string: "https://confluence.sbb.ch/display/RCAPP/Modelle"),
                        UIApplication.shared.canOpenURL(url) else {
                        return
                    }
                    UIApplication.shared.open(url)
                }) {
                    Text("Model Documentation")
                }
                    .buttonStyle(SBBSecondaryButtonStyle())
            }
            SBBOnboardingCardView(image: Image("Onboarding_Card2"), title: Text("iOS and Android Libraries"), text: Text("Libraries for iOS and Android allow developers to easily integrate automatically trained ML models.")) {
                Button(action: {
                    guard let url = URL(string: "https://code.sbb.ch/projects/KD_ESTA_MOBILE/repos/esta-mobile-ios-ml/browse"),
                        UIApplication.shared.canOpenURL(url) else {
                        return
                    }
                    UIApplication.shared.open(url)
                }) {
                    Text("Bitbucket")
                }
                    .buttonStyle(SBBSecondaryButtonStyle())
            }
            SBBOnboardingCardView(image: Image("Onboarding_Card3"), title: Text("Distance measurement"), text: Text("Optionally, SBB ML can also measure the distance to detected objects."))
            SBBOnboardingCardView(image: Image("Onboarding_Card4"), title: Text("Using the Libraries"), text: Text("The libraries are developed and maintained by the DSRV AppBakery. Please get in touch with us now.")) {
                Button(action: {
                    guard let url = URL(string: "https://sbb.sharepoint.com/sites/app-bakery/SitePages/Kontakt.aspx"),
                        UIApplication.shared.canOpenURL(url) else {
                        return
                    }
                    UIApplication.shared.open(url)
                }) {
                    Text("Contact us")
                }
                    .buttonStyle(SBBSecondaryButtonStyle())
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingView()
                .previewDisplayName("Light StartView")
                .environmentObject(OnboardingViewModel(onboardingState: .startView))
            OnboardingView()
                .previewDisplayName("Light CardsView")
                .environmentObject(OnboardingViewModel(onboardingState: .cardsView))
            OnboardingView()
                .previewDisplayName("Dark CardsView")
                .environment(\.colorScheme, .dark)
                .environmentObject(OnboardingViewModel(onboardingState: .cardsView))
            OnboardingView()
                .previewDisplayName("Light EndView")
                .environmentObject(OnboardingViewModel(onboardingState: .endView))
        }
    }
}
