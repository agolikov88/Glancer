//
//  Reminder.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 7/29/24.
//

import Foundation
import EventKit

struct Reminder: Equatable, Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var dueDate: Date? = nil
}

extension Reminder {
    
    init(with ekReminder: EKReminder) {
        id = ekReminder.calendarItemIdentifier
        title = ekReminder.title
        dueDate = ekReminder.dueDateComponents?.date
    }
}
