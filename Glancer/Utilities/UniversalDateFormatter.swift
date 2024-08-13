//
//  UniversalDateFormatter.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 8/12/24.
//

import Foundation

final class UniversalDateFormatter {
    
    class func formatDateBasedOnLocale(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        // Set locale to the user's current locale
        dateFormatter.locale = Locale.current
        
        return dateFormatter.string(from: date)
    }
}
