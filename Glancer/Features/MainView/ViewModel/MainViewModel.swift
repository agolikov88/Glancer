//
//  MainViewModel.swift
//  Glancer
//
//  Created by Alexander Golikov on 3/12/23.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    
    private let shareWatchFaceService: ShareWatchfaceService
    
    @Published var cardText = ""
    @Published var topicCard = TopicCard()
    
    private var cancellable = [AnyCancellable]()
    
    init(shareWatchFaceService: ShareWatchfaceService) {
        self.shareWatchFaceService = shareWatchFaceService
        
        $cardText
            .removeDuplicates()
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { text in
                self.updateCardPreview()
            }
            .store(in: &cancellable)
    }
    
    func addWatchFace() {
        shareWatchFaceService.generateWatchFace(topic: Topic(), topicCards: [topicCard])
            .flatMap { watchFaceURL in
                self.shareWatchFaceService.addWatchFace(watchFaceUrl: watchFaceURL)
            }
            .catch { error in
                return Fail(error: error)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error): print("Error \(error)")
                case .finished: print("Publisher is finished")
                }}, receiveValue: {result in print("Result: \(result)")}
            )
            .store(in: &cancellable)
    }
    
    private func updateCardPreview() {
        topicCard.cardDefinition = cardText
    }
}
