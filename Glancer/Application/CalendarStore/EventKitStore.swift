//
//  EventKitStore.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 7/20/24.
//

import Foundation
import EventKit

final class EventKitStore: ObservableObject {
    
    private let eventStore = EKEventStore()
    
    init() {
        
    }
    
    deinit {
        
    }
    
    func loadReminders() async throws -> [Reminder] {
        guard isAuthorized() else {
            throw EventKitError.accessDenied
        }
        
        let predicate = eventStore.predicateForReminders(in: nil)
        let ekReminders = try await eventStore.reminders(matching: predicate)
        let reminders: [Reminder] = try ekReminders.compactMap { ekReminder in
            do {
                return try Reminder(with: ekReminder)
            } catch EventKitError.reminderWithoutDueDate {
                return nil
            }
        }
        return reminders
    }
    
    private func isAuthorized() -> Bool {
        return EKEventStore.authorizationStatus(for: EKEntityType.reminder) == .authorized
    }
    
    func requestAccess() async throws {
        let status = EKEventStore.authorizationStatus(for: .reminder)
        switch status {
        case .authorized:
            return
        case .restricted:
            throw EventKitError.accessRestricted
        case .notDetermined:
            let accessGranted = try await eventStore.requestAccess(to: .reminder)
            guard accessGranted else {
                throw EventKitError.accessDenied
            }
        case .denied:
            throw EventKitError.accessDenied
        case .fullAccess:
            return
        case .writeOnly:
            throw EventKitError.accessDenied    // Read access is required...
        @unknown default:
            throw EventKitError.unknown
        }
    }
}
