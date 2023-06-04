//
//  CardsPreviewView.swift
//  WatchCards
//
//  Created by Alexander Golikov on 10/18/22.
//  Copyright © 2022 Alexander Golikov. All rights reserved.
//

import SwiftUI

struct CardsPreviewView: View {
    
    private var topicCard: TopicCard
    private var watchfaceFrame = "customization_frame"
    
    private let timer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()
    
    @State private var currentBackgroundIndex = 0
    @State private var showActivityIndicator = true
    
    init(topicCard: TopicCard, currentBackgroundIndex: Int, watchfaceFrame: String = "customization_frame") {
        self.topicCard = topicCard
        self.currentBackgroundIndex = currentBackgroundIndex
        self.watchfaceFrame = watchfaceFrame
    }
    
    var body: some View {
        ZStack {
            if (showActivityIndicator) {
                ProgressView().padding()
            } else {
                Image(uiImage: UIImage(named: topicCard.background)?.waterMarkedImage(text: topicCard.cardDefinition, color: topicCard.fontColor, font: topicCard.completeFontName()) ?? UIImage())
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
        CardsPreviewView(topicCard: TopicCard(id: "0", topicId: "111", cardDefinition: "Test"), currentBackgroundIndex: 0)
    }
}
