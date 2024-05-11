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
    case customizationViewOpened
    case selectBackgroundViewOpened
    case backgroundChanged
    case textPositionChanged
    case overlayChanged
    case fontChanged
    case fontSizeChanged
    case textColorChanged
    case cardAdded
    case cardRemoved
    case manageWatchfacesTapped
    
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
        case .customizationViewOpened:
            return "customization_view_opened"
        case .selectBackgroundViewOpened:
            return "select_background_view_opened"
        case .backgroundChanged:
            return "background_changed"
        case .textPositionChanged:
            return "text_position_changed"
        case .overlayChanged:
            return "overlay_changed"
        case .fontChanged:
            return "font_changed"
        case .fontSizeChanged:
            return "font__size_changed"
        case .textColorChanged:
            return "text_color_changed"
        case .cardAdded:
            return "card_added"
        case .cardRemoved:
            return "card_removed"
        case .manageWatchfacesTapped:
            return "manage_watchface_tapped"
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
