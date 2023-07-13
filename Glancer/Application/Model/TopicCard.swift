//
//  TopicCard.swift
//  WatchCards
//
//  Created by Alexander Golikov on 8/17/20.
//  Copyright © 2020 Alexander Golikov. All rights reserved.
//

import Foundation

struct TopicCard: Identifiable, Equatable {
    
    var id: String = UUID().uuidString
    var topicId: String = ""
    var cardDefinition: String = ""
    var background: String = "background1"
    var overlay: Bool = true
    var fontName: String = "AvenirNextCondensed"
    var fontStyle: String = "Medium"
    var fontColor: String = "FFFFFF"
    
    func completeFontName() -> String {
        return fontStyle.isEmpty ? "\(fontName)" : "\(fontName)-\(fontStyle)"
    }
}
