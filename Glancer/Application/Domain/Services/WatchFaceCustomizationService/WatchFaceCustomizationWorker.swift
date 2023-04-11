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
    
    private func parseJSONData(data: Data) -> CustomizationConfiguration {
        do {
            let decodedData = try JSONDecoder().decode(CustomizationConfiguration.self, from: data)
            return decodedData
        } catch {
            print("error: \(error)")
        }
        return CustomizationConfiguration()
    }
}

extension WatchFaceCustomizationWorker: WatchFaceCustomizationService {
    
    func readCustomizationConfiguration() -> CustomizationConfiguration {
        if let jsonData = readJSONFile(fileName: "CustomizationConfiguration") {
            return parseJSONData(data: jsonData)
        }
        
        return CustomizationConfiguration()
    }
}
