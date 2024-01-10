//
//  AppSettings.swift
//  Glancer
//
//  Created by Alexander Golikov on 4/2/23.
//

import Foundation

enum AppSettings {
    
    private static let showTutorialKey = "show_tutorial"
    private static let attachLogsKey = "attach_logs"
    
    static func markTutorialViewed() {
        UserDefaults.standard.set(true, forKey: showTutorialKey)
    }
    
    static func isTutorialViewed() -> Bool {
        return UserDefaults.standard.bool(forKey: showTutorialKey)
    }
    
    static func toggleAttachLogs() {
        UserDefaults.standard.set(!isAttachLogsEnabled(), forKey: attachLogsKey)
    }
    
    static func isAttachLogsEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: attachLogsKey)
    }
}
