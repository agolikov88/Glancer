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
    
    func loadReminders() async throws -> [Reminder] {
        guard isAuthorized() else {
            throw EventKitError.accessDenied
        }
        
        let predicate = eventStore.predicateForReminders(in: nil)
        let ekReminders = try await eventStore.reminders(matching: predicate)
        let sortedReminders = ekReminders.sorted {
            if let dueDate1 = $0.dueDateComponents?.date, let dueDate2 = $1.dueDateComponents?.date {
                return dueDate1 > dueDate2
            } else if $0.dueDateComponents?.date != nil {
                return true
            } else if $1.dueDateComponents?.date != nil {
                return false
            } else {
                return $0.creationDate ?? Date.distantPast > $1.creationDate ?? Date.distantPast
            }
        }
        let reminders: [Reminder] = sortedReminders.compactMap { ekReminder in
            return Reminder(with: ekReminder)
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
