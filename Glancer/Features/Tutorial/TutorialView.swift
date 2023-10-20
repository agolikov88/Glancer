//
//  TutorialView.swift
//  Glancer
//
//  Created by Alexander Golikov on 4/1/23.
//

import SwiftUI
import SwiftUIPager

struct TutorialView: View {
    
    @EnvironmentObject private var store: Store
    
    @Binding var isShowing: Bool
    
    @State var showSubscriptionView = false
    
    @StateObject var page: Page = .first()
    
    var pages: [Int] {
        return store.isPaidSubscription ? Array(0..<1) : Array(0..<2)
    }
    
    var body: some View {
        VStack {
            Text("Tutorial")
                .font(.system(size: 28, weight: .bold, design: .default))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            
            Pager(page: self.page,
                  data: self.pages,
                  id: \.self) { pageNumber in
                if pageNumber == 0 {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            Image(systemName: "character.cursor.ibeam")
                                .font(.system(size: 28, design: .default))
                                .foregroundColor(Color(.systemOrange))
                                .padding(.trailing)
                            Text("Enter text you want to appear on your watch")
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
                                .foregroundColor(Color(.systemOrange))
                                .padding(.trailing)
                            Text("Hit “Send to Watch” button")
                                .font(.system(size: 22, design: .default))
                        }
                        VStack {
                            Image(systemName: "arrow.down")
                                .font(.system(size: 28, design: .default))
                                .foregroundColor(Color(.systemGray))
                        }
                        .frame(maxWidth: .infinity)
                        HStack {
                            Image(systemName: "applewatch.watchface")
                                .font(.system(size: 28, design: .default))
                                .foregroundColor(Color(.systemOrange))
                                .padding(.trailing)
                            Text("Add new watch face to your watch")
                                .font(.system(size: 22, design: .default))
                        }
                        VStack {
                            Image(systemName: "arrow.down")
                                .font(.system(size: 28, design: .default))
                                .foregroundColor(Color(.systemGray))
                        }
                        .frame(maxWidth: .infinity)
                        HStack {
                            Image(systemName: "arrow.clockwise.circle")
                                .font(.system(size: 28, design: .default))
                                .foregroundColor(Color(.systemOrange))
                                .padding(.trailing)
                            Text("Repeat:)")
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
                            Text(pages.count > 1 ? "Next" : "Got it!")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.buttonBackgroundOrange)
                                .cornerRadius(16)
                                .foregroundColor(.white)
                        }
                    }
                } else {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            Image(systemName: "goforward.plus")
                                .font(.system(size: 28, design: .default))
                                .foregroundColor(Color.mint)
                                .padding(.trailing)
                            Text("Unlock all features")
                                .font(.system(size: 22, design: .default))
                        }
                        VStack {
                            Image(systemName: "arrow.down")
                                .font(.system(size: 28, design: .default))
                                .foregroundColor(Color(.systemGray))
                        }
                        .frame(maxWidth: .infinity)
                        HStack {
                            Image(systemName: "sparkles.rectangle.stack")
                                .font(.system(size: 28, design: .default))
                                .foregroundColor(Color(.systemGreen))
                                .padding(.trailing)
                            Text("Create up to 24 cards per watch album")
                                .font(.system(size: 22, design: .default))
                        }
                        VStack {
                            Image(systemName: "arrow.down")
                                .font(.system(size: 28, design: .default))
                                .foregroundColor(Color(.systemGray))
                        }
                        .frame(maxWidth: .infinity)
                        HStack {
                            Image(systemName: "paintbrush.pointed")
                                .font(.system(size: 28, design: .default))
                                .foregroundColor(Color.blue)
                                .padding(.trailing)
                            Text("Use custom fonts, backgrounds and colors for your cards")
                                .font(.system(size: 22, design: .default))
                        }
                        VStack {
                            Image(systemName: "arrow.down")
                                .font(.system(size: 28, design: .default))
                                .foregroundColor(Color(.systemGray))
                        }
                        .frame(maxWidth: .infinity)
                        Button(action: {
                            showSubscriptionView = true
                        }) {
                            VStack() {
                                Text("Unlock All")
                                    .font(.custom("Cookie-Regular", size: 32))
                            }
                            .frame(maxWidth: .infinity, minHeight: 60, alignment: .center)
                            .padding([.leading, .trailing])
                            .background(LinearGradient(gradient: Gradient(colors: [Color("dark_green"), Color("light_green")]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(16)
                            .foregroundColor(.white)
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
            AppSettings.markTutorialViewed()
        }
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView(isShowing: .constant(true))
    }
}
