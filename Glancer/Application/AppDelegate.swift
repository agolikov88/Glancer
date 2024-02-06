//
//  AppDelegate.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 2/5/24.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func applicationWillTerminate(_ application: UIApplication) {
        Logger.info("App exit...")
        // test...
        //DispatchQueue.global().async {  // TODO: update to use structured concurrency...
            do {
                try FileManager.default.clearTmpDirectory()
            } catch {
                Logger.warning("Failed to cleanup tmp directory!")
            }
        //}
    }
}
