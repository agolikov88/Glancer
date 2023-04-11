//
//  CustomFonts.swift
//  Glancer
//
//  Created by Alexander Golikov on 4/9/23.
//

import Foundation

enum SupportedFontWeights: Int, CaseIterable {
    case regular = 0
    case medium = 1
    case bold = 2
    
    init(index: Double = 0) {
        if let type = Self.allCases.first(where: { $0.asIndex == index }) {
            self = type
        } else {
            self = .regular
        }
    }

    var asIndex: Double {
        switch self {
        case .regular: return 0
        case .medium: return 1
        case .bold: return 2
        }
    }
}

struct CustomizationConfiguration: Decodable {
    
    var supportedFonts: [String: [Int: String]] = ["Avenir Next Condensed": [0: "Regular", 1: "Medium", 2: "Bold"]]
    var supportedBackgrounds: [String] = ["background1"]
}
