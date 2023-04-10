//
//  MainViewModel.swift
//  Glancer
//
//  Created by Alexander Golikov on 3/12/23.
//

import Foundation
import Combine

enum WatchFaceState {
    
    case initial
    case generating
    case created
    case failed
}

final class MainViewModel: ObservableObject {
    
    private let shareWatchFaceService: ShareWatchfaceService
    private let watchFaceCustomizationService: WatchFaceCustomizationService
    
    @Published var cardText = ""
    @Published var topicCard = TopicCard()
    
    @Published private(set) var watchFaceState: WatchFaceState = .initial
    
    let supportedFonts: CustomFonts
    
    private var cancellable = [AnyCancellable]()
    
    init(shareWatchFaceService: ShareWatchfaceService, watchFaceCustomizationService: WatchFaceCustomizationService) {
        self.shareWatchFaceService = shareWatchFaceService
        self.watchFaceCustomizationService = watchFaceCustomizationService
        
        supportedFonts = watchFaceCustomizationService.readCustomFontsConfiguration()
        
        $cardText
            .removeDuplicates()
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { text in
                self.updateCardPreview()
            }
            .store(in: &cancellable)
    }
    
    func addWatchFace() {
        watchFaceState = .generating
        shareWatchFaceService.generateWatchFace(topic: Topic(), topicCards: [topicCard])
            .flatMap { watchFaceURL in
                self.shareWatchFaceService.addWatchFace(watchFaceUrl: watchFaceURL)
            }
            .catch { error in
                return Fail(error: error)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(_): self.watchFaceState = .failed
                case .finished: self.watchFaceState = .created
                }}, receiveValue: {[weak self] result in
                    if !result {
                        self?.watchFaceState = .failed
                        
                    }
                }
            )
            .store(in: &cancellable)
    }
    
    private func updateCardPreview() {
        topicCard.cardDefinition = cardText
    }
    
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
    
    private func parse(jsonData: Data) -> CustomFonts {
        do {
            let decodedData = try JSONDecoder().decode(CustomFonts.self, from: jsonData)
            return decodedData
        } catch {
            print("error: \(error)")
        }
        return CustomFonts()
    }
}
