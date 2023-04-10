//
//  WatchFaceCustomizationWorker.swift
//  Glancer
//
//  Created by Alexander Golikov on 4/9/23.
//

import Foundation

final class WatchFaceCustomizationWorker {
    
    private func readJSONFile(fileName: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: fileName, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print("error: \(error)")
        }
        
        return nil
    }
    
    private func parseJSONData(data: Data) -> CustomFonts {
        do {
            let decodedData = try JSONDecoder().decode(CustomFonts.self, from: data)
            return decodedData
        } catch {
            print("error: \(error)")
        }
        return CustomFonts()
    }
}

extension WatchFaceCustomizationWorker: WatchFaceCustomizationService {
    
    func readCustomFontsConfiguration() -> CustomFonts {
        if let jsonData = readJSONFile(fileName: "CustomFonts") {
            return parseJSONData(data: jsonData)
        }
        
        return CustomFonts()
    }
}
