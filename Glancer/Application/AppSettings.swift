//
//  AppSettings.swift
//  Glancer
//
//  Created by Alexander Golikov on 4/2/23.
//

import Foundation

struct AppSettings {
    
    private static let showTutorialKey = "show_tutorial"
    private static let paidSubscription = "paid_subscription"
    
    static func markTutorialViewed() {
        UserDefaults.standard.set(true, forKey: showTutorialKey)
    }
    
    static func isTutorialViewed() -> Bool {
        return UserDefaults.standard.bool(forKey: showTutorialKey)
    }
}
