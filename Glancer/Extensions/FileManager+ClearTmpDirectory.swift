//
//  FileManager+ClearTmpDirectory.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 2/5/24.
//

import Foundation

extension FileManager {
    
    @discardableResult
    func clearTmpDirectory() throws -> Bool  {
        // test...
//        if Thread.isMainThread {
//            let mainThreadWarningMessage = "\(#file) - \(#function) executed on main thread. Do not block the main thread."
//            assertionFailure(mainThreadWarningMessage)
//        }
        
        do {
            let tmpDirURL = FileManager.default.temporaryDirectory
            let tmpDirectoryContent = try contentsOfDirectory(atPath: tmpDirURL.path)
            
            guard tmpDirectoryContent.count != 0 else {
                return true
            }
            
            for tmpFilePath in tmpDirectoryContent {
                let trashFileURL = tmpDirURL.appendingPathComponent(tmpFilePath)
                try removeItem(atPath: trashFileURL.path)
            }
            
            let tmpDirectoryContentAfterDeletion = try contentsOfDirectory(atPath: tmpDirURL.path)
            
            return tmpDirectoryContentAfterDeletion.count == 0
        } catch let directoryAccessError {
            throw directoryAccessError
        }
    }
}
