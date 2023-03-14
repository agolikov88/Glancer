//
//  MainViewModel.swift
//  Glancer
//
//  Created by Alexander Golikov on 3/12/23.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    
    @Published var cardText = ""
    @Published var topicCard = TopicCard()
    
    private var cancellable = [AnyCancellable]()
    
    init() {
        $cardText
            .removeDuplicates()
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { text in
                self.updateCardPreview()
            }
            .store(in: &cancellable)
    }
    
    private func updateCardPreview() {
        topicCard.cardDefinition = cardText
    }
}
