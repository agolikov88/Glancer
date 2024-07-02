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
    case reviewRequestShown
    
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
        case .reviewRequestShown:
            return "review_request_shown"
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
    
    class func customizationViewOpened() {
        event(with: .customizationViewOpened)
    }
    
    class func selectBackgroundViewOpened() {
        event(with: .selectBackgroundViewOpened)
    }
    
    class func backgroundChanged() {
        event(with: .backgroundChanged)
    }
    
    class func textPositionChanged() {
        event(with: .textPositionChanged)
    }
    
    class func overlayChanged() {
        event(with: .overlayChanged)
    }
    
    class func fontChanged() {
        event(with: .fontChanged)
    }
    
    class func fontSizeChanged() {
        event(with: .fontSizeChanged)
    }
    
    class func textColorChanged() {
        event(with: .textColorChanged)
    }
    
    class func cardAdded(cardsNumber: Int) {
        event(with: .cardAdded, parameters: ["cards_number": cardsNumber])
    }
    
    class func cardRemoved(cardsNumber: Int) {
        event(with: .cardRemoved, parameters: ["cards_number": cardsNumber])
    }
    
    class func manageWatchfacesTapped() {
        event(with: .manageWatchfacesTapped)
    }
    
    class func reviewRequestShown() {
        event(with: .reviewRequestShown)
    }
}
