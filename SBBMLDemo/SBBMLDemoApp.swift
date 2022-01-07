//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import SwiftUI
import SBBDesignSystemMobileSwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        SBBAppearance.setupSBBAppearance()
        return true
    }
}

@main
struct SBBMLDemoApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let onboardingViewModel = OnboardingViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(onboardingViewModel)
        }
    }
}
