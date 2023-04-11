//
//  WatchFaceCustomizationService.swift
//  Glancer
//
//  Created by Alexander Golikov on 4/9/23.
//

import Foundation

protocol WatchFaceCustomizationService {
    
    func readCustomizationConfiguration() -> CustomizationConfiguration
}
