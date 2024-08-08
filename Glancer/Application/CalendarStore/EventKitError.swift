//
//  EventKitError.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 7/29/24.
//

import Foundation

enum EventKitError: LocalizedError {
    case accessDenied
    case accessRestricted
    case failedFetchingReminders
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return NSLocalizedString(
                "The app doesn't have permission to read reminders.", comment: "Reminders access denied error")
        case .accessRestricted:
            return NSLocalizedString(
                "This device doesn't allow access to reminders.", comment: "Reminders access restricted error")
        case .failedFetchingReminders:
            return NSLocalizedString(
                "Failed to fetch reminders.", comment: "Failed fetching reminders error")
        case .unknown:
            return NSLocalizedString("An unknown error occurred.", comment: "Unknown error")
        }
    }
}
