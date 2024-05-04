//
//  AnalyticsManager.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 5/3/24.
//

import Foundation
import FirebaseAnalytics

enum AnalyticsEvent {
    case purchaseSuccess
    case purchaseCancelled
    case purchasePending
    case watchFaceCreated
    
    var name: String {
        switch self {
        case .purchaseSuccess:
            return "purchase_success"
        case .purchaseCancelled:
            return "purchase_cancelled"
        case .purchasePending:
            return "purchase_pending"
        case .watchFaceCreated:
            return "watchface_created"
        }
    }
}

final class AnalyticsManager {
    
    private class func event(with type: AnalyticsEvent, parameters: [String: Any]? = nil) {
        Analytics.logEvent(type.name, parameters: parameters)
    }
}

extension AnalyticsManager {
    
    class func purchaseSuccessEvent() {
        event(with: .purchaseSuccess)
    }
    
    class func purchaseCancelledEvent() {
        event(with: .purchaseCancelled)
    }
    
    class func purchasePendingEvent() {
        event(with: .purchasePending)
    }
    
    class func watchFaceCreatedEvent() {
        event(with: .watchFaceCreated)
    }
}
