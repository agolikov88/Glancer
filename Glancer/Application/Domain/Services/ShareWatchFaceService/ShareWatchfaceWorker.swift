//
//  ShareWatchfaceWorker.swift
//  WatchCards
//
//  Created by Alexander Golikov on 11/22/21.
//  Copyright © 2021 Alexander Golikov. All rights reserved.
//

import Foundation
import Combine
import ClockKit
import ZIPFoundation

enum ShareWatchfaceError: Error {

    case wrongWatchFaceURL(errorMessage: String)
    case notSupportedOSWersion(errorMessage: String)
    case watchFaceCreationError(errorMessage: String)
}

final class ShareWatchfaceWorker {

    private let fileManager = FileManager.default
    
    private let watchFaceFolderName = "WatchFace"
    private let watchFaceResourcesFolderName = "Resources"
    private let imagesPlistFileName = "Images.plist"
    
    private let defaultBackgroundImageName = "background1"
    private let defaultFont = "AvenirNextCondensed-Regular"
    
    private func copyBundleResources(resourceNames: [String], destination: URL) throws {
        for resource in resourceNames {
            guard let bundlePath = Bundle.main.resourceURL?.appendingPathComponent(resource).path else {
                continue
            }
            
            try fileManager.copyItem(atPath: bundlePath, toPath: destination.appendingPathComponent(resource).path)
        }
    }
    
    private func createImagesWithText(topicCards: [TopicCard], storeUrl: URL) -> [String] {
        var imageNames: [String] = []
        for topicCard in topicCards {
            var image: UIImage?
            DispatchQueue.main.sync {
                image = UIImage(named: topicCard.background)?.waterMarkedImage(text: topicCard.cardDefinition, color: topicCard.fontColor, font: topicCard.completeFontName()) ?? UIImage()
            }
            guard let image = image, let imageData = image.jpegData(compressionQuality: 0.7) else {
                continue
            }
            do {
                let imageFileName = UUID().uuidString + ".jpg"
                let imageFileUrl = storeUrl.appendingPathComponent(imageFileName)
                try imageData.write(to: imageFileUrl)
                imageNames.append(imageFileName)
            }
            catch {
            }
        }
        return imageNames
    }
    
    private func generateImagesPlist(imageNames: [String], storeUrl: URL) throws {
        var imagesConfig = ImagesConfig()
        for imageName in imageNames {
            var imageConfig = ImageConfig()
            imageConfig.imageURL = imageName
            imagesConfig.imageList.append(imageConfig)
        }
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        let path = storeUrl.appendingPathComponent(imagesPlistFileName)
        
        let data = try encoder.encode(imagesConfig)
        try data.write(to: path)
    }
}

extension ShareWatchfaceWorker: ShareWatchfaceService {
    
    func generateWatchFace(topicCards: [TopicCard]) -> AnyPublisher<URL, Error> {
        Future { promise in
            DispatchQueue.global().async { [self] in
                do {
                    let rootFolder = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let watchFaceFolder = rootFolder.appendingPathComponent(watchFaceFolderName)
                    //TODO: check if directory already exists and clean it before proceeding...
                    try fileManager.createDirectory(at: watchFaceFolder, withIntermediateDirectories: false, attributes: nil)
                    defer {
                        try? fileManager.removeItem(at: watchFaceFolder)
                    }
                    let watchFaceResourcesFolder = watchFaceFolder.appendingPathComponent(watchFaceResourcesFolderName)
                    try fileManager.createDirectory(at: watchFaceResourcesFolder, withIntermediateDirectories: false, attributes: nil)
                    
                    let bundleResourcesNames = ["face.json", "metadata.json", "no_borders_snapshot.png", "snapshot.png"]
                    try copyBundleResources(resourceNames: bundleResourcesNames, destination: watchFaceFolder)
                    
                    try generateImagesPlist(imageNames: createImagesWithText(topicCards: topicCards, storeUrl: watchFaceResourcesFolder), storeUrl: watchFaceResourcesFolder)
                    
                    let watchFaceURL = rootFolder.appendingPathComponent(UUID().uuidString + ".watchface")
                    try fileManager.zipItem(at: watchFaceFolder, to: watchFaceURL, shouldKeepParent: false, compressionMethod: .deflate)
                    
                    promise(.success(watchFaceURL))
                }
                catch {
                    promise(.failure(ShareWatchfaceError.watchFaceCreationError(errorMessage: "Error creating watchface archive")))
                }
            }
        }.eraseToAnyPublisher()
    }

    func addWatchFace(watchFaceUrl: URL) -> AnyPublisher<Bool, Error> {
        Future { promise in
            let library = CLKWatchFaceLibrary()
            library.addWatchFace(at: watchFaceUrl) { error in
                do {
                    try self.fileManager.removeItem(at: watchFaceUrl)
                }
                catch {
                }
                if let error = error {
                    promise(.failure(ShareWatchfaceError.notSupportedOSWersion(errorMessage: error.localizedDescription)))
                } else {
                    promise(.success(true))
                }
            }
        }.eraseToAnyPublisher()
    }
}
