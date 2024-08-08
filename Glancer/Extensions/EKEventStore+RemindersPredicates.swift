//
//  EKEventStore+RemindersPredicates.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 8/7/24.
//

import Foundation
import EventKit

extension EKEventStore {
    
    func predicateForRemindersCreated(after date: Date) -> NSPredicate {
        return NSPredicate(format: "creationDate >= %@", date as CVarArg)
    }
    
    func predicateForRemindersDue(after date: Date, calendars: [EKCalendar]?) -> NSPredicate {
        return predicateForIncompleteReminders(withDueDateStarting: date, ending: nil, calendars: calendars)
    }
}
