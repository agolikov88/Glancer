//
//  ImagePlaygroundAvailability.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 12/27/24.
//

import Foundation
import SwiftUI
import ImagePlayground

@available(iOS 18, *)
struct ImagePlaygroundAvailability {
    
    @Environment(\.supportsImagePlayground) private static var supportsImagePlayground
    
    static func imagePlaygroundSupported() -> Bool {
        return supportsImagePlayground
    }
}
