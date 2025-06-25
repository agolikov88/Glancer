//
//  ImagePlaygroundTutorialView.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 1/4/25.
//

import SwiftUI
import SwiftUIPager

struct InAppEventView: View {
    
    @Binding var isShowing: Bool
    
    @StateObject var page: Page = .first()
    
    var pages: [Int] {
        return Array(0..<1)
    }
    
    var body: some View {
        VStack {
            Text("What's New")
                .font(.system(size: 28, weight: .bold, design: .default))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            
            Pager(page: self.page,
                  data: self.pages,
                  id: \.self) { pageNumber in
                if pageNumber == 0 {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack {
                            Image("in_app_event_free")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 256)
                                .padding(.trailing, 10.0)
                        }
                        .frame(maxWidth: .infinity)
                        HStack {
                            Image(systemName: "info.circle")
                                .font(.system(size: 28, design: .default))
                                .foregroundColor(Color.mint)
                                .padding(.trailing)
                            Text("All features in the app are now available for free!")
                                .font(.system(size: 22, design: .default))
                        }
                        Spacer()
                        Button(action: {
                            isShowing = false
                        }) {
                            Text("Got it!")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.buttonBackgroundOrange)
                                .cornerRadius(16)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .swipeInteractionArea(.allAvailable)
            .itemSpacing(10)
        }
        .padding(28)
        .onAppear {
            AppSettings.markNewFeatureViewed()
        }
    }
}

#Preview {
    ImagePlaygroundTutorialView(isShowing: .constant(true))
}
