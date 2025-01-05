//
//  ImagePlaygroundTutorialView.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 1/4/25.
//

import SwiftUI

struct ImagePlaygroundTutorialView: View {
    var body: some View {
        VStack {
            Text("New Image Playground feature!")
        }
        .onAppear {
            AppSettings.markNewFeatureViewed()
        }
    }
}

#Preview {
    ImagePlaygroundTutorialView()
}
