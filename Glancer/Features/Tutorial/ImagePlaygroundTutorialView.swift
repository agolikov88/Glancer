//
//  ImagePlaygroundTutorialView.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 1/4/25.
//

import SwiftUI
import SwiftUIPager

struct ImagePlaygroundTutorialView: View {
    
    @EnvironmentObject private var store: Store
    
    @Binding var isShowing: Bool
    
    @State var showSubscriptionView = false
    
    @StateObject var page: Page = .first()
    
    var pages: [Int] {
        return Array(0..<2)
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
                        HStack {
                            Image(systemName: "wand.and.sparkles")
                                .font(.system(size: 28, design: .default))
                                .foregroundColor(Color.mint)
                                .padding(.trailing)
                            Text("Generate beautiful new backgrounds with AI!")
                                .font(.system(size: 22, design: .default))
                        }
                        VStack {
                            Image(systemName: "arrow.down")
                                .font(.system(size: 28, design: .default))
                                .foregroundColor(Color(.systemGray))
                        }
                        .frame(maxWidth: .infinity)
                        HStack {
                            Image(systemName: "hand.tap")
                                .font(.system(size: 28, design: .default))
                                .foregroundColor(Color.mint)
                                .padding(.trailing)
                            Text("Tap on card preview")
                                .font(.system(size: 22, design: .default))
                        }
                        VStack {
                            Image(systemName: "arrow.down")
                                .font(.system(size: 28, design: .default))
                                .foregroundColor(Color(.systemGray))
                        }
                        .frame(maxWidth: .infinity)
                        HStack {
                            Image(systemName: "photo")
                                .font(.system(size: 28, design: .default))
                                .foregroundColor(Color.mint)
                                .padding(.trailing)
                            Text("Tap on backgrounds button")
                                .font(.system(size: 22, design: .default))
                        }
                        VStack {
                            Image(systemName: "arrow.down")
                                .font(.system(size: 28, design: .default))
                                .foregroundColor(Color(.systemGray))
                        }
                        .frame(maxWidth: .infinity)
                        HStack {
                            Image(systemName: "sparkles")
                                .font(.system(size: 28, design: .default))
                                .foregroundColor(Color.mint)
                                .padding(.trailing)
                            Text("Tap on sparkles to start the magic!")
                                .font(.system(size: 22, design: .default))
                        }
                        Spacer()
                        Button(action: {
                            if pages.count > 1 {
                                withAnimation {
                                    page.update(.moveToLast)
                                }
                            } else {
                                isShowing = false
                            }
                        }) {
                            Text("Next")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(gradient: Gradient(colors: [Color("dark_green"), Color("light_green")]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(16)
                                .foregroundColor(.white)
                        }
                    }
                } else {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack {
                            Image("generate_image_tutorial")
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
                            Text("Feature is ONLY supported on iPhone 15 Pro and up")
                                .font(.system(size: 22, design: .default))
                        }
                        if !store.isPaidSubscription {
                            Button(action: {
                                showSubscriptionView = true
                            }) {
                                VStack() {
                                    Text("Unlock this feature!")
                                        .font(.custom("Cookie-Regular", size: 32))
                                }
                                .frame(maxWidth: .infinity, minHeight: 60, alignment: .center)
                                .padding([.leading, .trailing])
                                .background(LinearGradient(gradient: Gradient(colors: [Color("dark_green"), Color("light_green")]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(16)
                                .foregroundColor(.white)
                            }
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
            .sheet(isPresented: $showSubscriptionView) {
                SubscriptionView(isShowing: $showSubscriptionView) {
                    isShowing = false
                }
            }
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
