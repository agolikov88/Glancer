//
//  ShareWatchfaceService.swift
//  WatchCards
//
//  Created by Alexander Golikov on 11/22/21.
//  Copyright © 2021 Alexander Golikov. All rights reserved.
//

import Foundation
import Combine

protocol ShareWatchfaceService {

    func generateWatchFace(topicCards: [TopicCard]) -> AnyPublisher<URL, Error>
    func addWatchFace(watchFaceUrl: URL) -> AnyPublisher<Bool, Error>
}
