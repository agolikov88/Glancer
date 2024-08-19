//
//  RemindersViewModel.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 8/2/24.
//

import Foundation

enum RemindersState {
    
    case initial
    case loaded
    case accessDenied
}

final class RemindersViewModel: ObservableObject {
    
    var eventStore: EventKitStore
    
    @Published var reminders: [Reminder] = []
    @Published var remindersState: RemindersState = .initial
    
    init(eventStore: EventKitStore) {
        self.eventStore = eventStore
    }
    
    @MainActor
    func loadReminders() {
        Task {
            do {
                try await eventStore.requestAccess()
                reminders = try await eventStore.loadReminders()
                remindersState = .loaded
            } catch {
                remindersState = .accessDenied
                Logger.warning("Error accessing reminders: \(error.localizedDescription)")
            }
        }
    }
}
