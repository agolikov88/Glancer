//
//  Topic.swift
//  WatchCards
//
//  Created by Alexander Golikov on 7/26/20.
//  Copyright © 2020 Alexander Golikov. All rights reserved.
//

import Foundation

struct Topic: Identifiable {
    
    var id = ""    
    var topicName = ""
    var cardsNumber = 0
    var lastAccessedDate = Date()
    var topicBackgrounds: [String] = []
    var topicFont = "Avenir Next Condensed Regular"
    var topicFontColor = "FFFFFF"
}
