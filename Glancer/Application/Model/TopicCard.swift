//
//  TopicCard.swift
//  WatchCards
//
//  Created by Alexander Golikov on 8/17/20.
//  Copyright © 2020 Alexander Golikov. All rights reserved.
//

import Foundation

struct TopicCard: Identifiable {
    
    var id: String = UUID().uuidString
    var topicId: String = ""
    var cardDefinition: String = ""
    var background: String = "background1"
}
