//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import SwiftUI
import SBBML

struct ErrorView: View {
    
    let error: ObjectDetectionError
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            Image(sbbName: "camera", size: .medium)
            Text("An error occured")
                .sbbFont(.copy)
            Text(error.localizedDescription)
                .sbbFont(.legend)
                .foregroundColor(Color.sbbColor(.textMetal))
            Spacer()
        }
            .padding(16)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: .noCamerasAvailable)
    }
}
