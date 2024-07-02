//
//  Bundle+AppVersion.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 7/1/24.
//

import Foundation

extension Bundle {
    /// Fetches the current bundle version of the app.
    static var currentAppVersion: String? {
        let infoDictionaryKey = "CFBundleVersion"
        
        return Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
    }
}
