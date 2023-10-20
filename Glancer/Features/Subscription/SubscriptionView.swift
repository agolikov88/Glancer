//
//  SubscriptionView.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 6/19/23.
//

import SwiftUI
import StoreKit

struct SubscriptionView: View {
    
    @Binding var isShowing: Bool
    
    @EnvironmentObject private var store: Store
    
    let onSubscribtionActivated: (() -> Void)?
    
    init(isShowing: Binding<Bool>, onSubscribtionActivated: (() -> Void)? = nil) {
        self._isShowing = isShowing
        self.onSubscribtionActivated = onSubscribtionActivated
    }
    
    var body: some View {
        VStack {
            // TODO: need to fetch product data right before processing purchase on button click, otherwise there might be a delay on first launch of this view, also might get infinite progress indicator if no internet connection present...
            if store.products.isEmpty {
                ProgressView()
            } else {
                Text("Unlock All")
                    .font(.custom("Cookie-Regular", size: 36))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .red, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Image(systemName: "sparkles.rectangle.stack")
                            .font(.system(size: 28, design: .default))
                            .foregroundColor(Color(.systemGreen))
                            .padding(.trailing)
                        Text("Create up to 24 cards per watch album")
                            .font(.system(size: 18, design: .default))
                    }
                    HStack {
                        Image(systemName: "paintbrush.pointed")
                            .font(.system(size: 28, design: .default))
                            .foregroundColor(Color.blue)
                            .padding(.trailing)
                        Text("Use custom fonts, backgrounds and colors for your cards")
                            .font(.system(size: 18, design: .default))
                    }
                    HStack {
                        Image(systemName: "photo.circle")
                            .font(.system(size: 28, design: .default))
                            .foregroundColor(Color.mint)
                            .padding(.trailing)
                        Text("Choose from a selection of custom app icons")
                            .font(.system(size: 18, design: .default))
                    }
                    Button(action: {
                        //test... TODO: add product purchase logic here...
                        Task {
                            do {
                                try await store.purchase(store.products[0])
                            } catch {
                                print(error)
                            }
                        }
                    }) {
                        VStack(alignment: .leading) {
                            Text("Monthly")
                                .font(.system(size: 22, weight: .medium, design: .default))
                                .padding(.bottom, 1)
                            Text("$2,99")
                                .font(.system(size: 22, weight: .bold, design: .default))
                        }
                        .frame(maxWidth: .infinity, minHeight: 80, alignment: .leading)
                        .padding([.leading, .trailing])
                        .background(LinearGradient(gradient: Gradient(colors: [Color("dark_green"), Color("light_green")]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(16)
                        .foregroundColor(.white)
                    }
                    Button(action: {
                        
                    }) {
                        VStack(alignment: .leading) {
                            Text("Yearly")
                                .font(.system(size: 22, weight: .medium, design: .default))
                                .padding(.bottom, 1)
                            Text("$14,99")
                                .font(.system(size: 22, weight: .bold, design: .default))
                            Text("Pay just $1,24 monthly")
                                .font(.system(size: 18  , weight: .regular, design: .default))
                        }
                        .frame(maxWidth: .infinity, minHeight: 80, alignment: .leading)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.mint]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(16)
                        .foregroundColor(.white)
                    }
                    Button(action: {
                        
                    }) {
                        VStack(alignment: .leading) {
                            Text("Lifetime")
                                .font(.system(size: 22, weight: .medium, design: .default))
                                .padding(.bottom, 1)
                            Text("$34,99")
                                .font(.system(size: 22, weight: .bold, design: .default))
                            Text("One-time payment")
                                .font(.system(size: 18  , weight: .regular, design: .default))
                        }
                        .frame(maxWidth: .infinity, minHeight: 80, alignment: .leading)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(16)
                        .foregroundColor(.white)
                    }
                }
                Spacer()
            }
        }
        .padding([.leading, .trailing], 28)
        .onChange(of: store.isPaidSubscription, perform: {unlockedAll in
            if unlockedAll {
                onSubscribtionActivated?()
                isShowing = false
            }
        })
        .task {
            await store.fetchProducts()
        }
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView(isShowing: .constant(true))
    }
}
