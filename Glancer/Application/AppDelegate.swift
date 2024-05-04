//
//  AppDelegate.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 2/5/24.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Logger.info("App launched...")
        Logger.info("Configuring Firebase Analytics...")
        FirebaseConfigurator.configureFirebase()
        let tmpCleaner = TmpDirectoryCleaner()
        Task {
            await tmpCleaner.clearTmpDirectory()
        }
        Logger.info("didFinishLaunchingWithOptions completed")
        
        return true
    }    
}

actor TmpDirectoryCleaner {
    
    func clearTmpDirectory() async {
        do {
            try FileManager.default.clearTmpDirectory()
            Logger.info("Tmp directory cleared")
        } catch {
            Logger.warning("Failed to cleanup tmp directory!")
        }
    }
}
