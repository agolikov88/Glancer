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
    
    @Published var topicCards = [TopicCard()]
    @Published var currentPageIndex = 0
    @Published var previousCardsNumber = 1
    @Published var clearImagesCache = false
    
    @Published private(set) var watchFaceState: WatchFaceState = .initial
    
    let customizationConfiguration: CustomizationConfiguration
    
    private var cancellable = [AnyCancellable]()
    
    init(shareWatchFaceService: ShareWatchfaceService, watchFaceCustomizationService: WatchFaceCustomizationService) {
        self.shareWatchFaceService = shareWatchFaceService
        self.watchFaceCustomizationService = watchFaceCustomizationService
        
        customizationConfiguration = watchFaceCustomizationService.readCustomizationConfiguration()
        
        // TODO: possibly bring back debounce support in future to avoid unnecessary preview images regenerations on every text input...
//        $cardText
//            .removeDuplicates()
//            .debounce(for: 0.3, scheduler: DispatchQueue.main)
//            .sink { text in
//                self.updateCardPreview()
//            }
//            .store(in: &cancellable)
    }
    
    func addWatchFace() {
        watchFaceState = .generating
        shareWatchFaceService.generateWatchFace(topicCards: topicCards)
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
    
    func clearCards() {
        topicCards = [TopicCard()]
        currentPageIndex = 0
        previousCardsNumber = 1
        clearImagesCache.toggle()
    }
}
