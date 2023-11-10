//
//  CardsPreviewView.swift
//  WatchCards
//
//  Created by Alexander Golikov on 10/18/22.
//  Copyright © 2022 Alexander Golikov. All rights reserved.
//

import SwiftUI

struct CardsPreviewView: View {
    
    private var cardImage: UIImage
    private var watchfaceFrame = "customization_frame"
    
    private let timer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()
    
    @State private var showActivityIndicator = true
    
    init(cardImage: UIImage, watchfaceFrame: String = "customization_frame") {
        self.cardImage = cardImage
        self.watchfaceFrame = watchfaceFrame
    }
    
    var body: some View {
        ZStack {
            if (showActivityIndicator) {
                ProgressView().padding()
            } else {
                Image(uiImage: cardImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 198)
                    .padding(.trailing, 10.0)
                Image("watchface_overlay")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 198)
                    .padding(.trailing, 10.0)
            }
            Image(watchfaceFrame)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 222)
        }
        .frame(width: 222)
        .onReceive(timer) { _ in
            timer.upstream.connect().cancel()
            showActivityIndicator = false
        }
    }
}

struct CardsPreviewView_Previews: PreviewProvider {
    
    static var previews: some View {
        CardsPreviewView(cardImage: UIImage())
    }
}
