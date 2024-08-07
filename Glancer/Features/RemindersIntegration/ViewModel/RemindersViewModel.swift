//
//  RemindersViewModel.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 8/2/24.
//

import Foundation

final class RemindersViewModel: ObservableObject {
    
    var eventStore: EventKitStore
    
    init(eventStore: EventKitStore) {
        self.eventStore = eventStore
    }
    
    // test...
    func loadReminders() {
        Task {
            do {
                try await eventStore.requestAccess()
            } catch {
                Logger.warning("Error accessing reminders: \(error.localizedDescription)")
            }
        }
    }
}
