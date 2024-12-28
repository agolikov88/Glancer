//
//  SelectCustomBackgroundViewModel.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 1/20/24.
//

import Foundation
import _PhotosUI_SwiftUI

final class SelectCustomBackgroundViewModel: ObservableObject {
    
    @Published var selectedPhotos = [PhotosPickerItem]()
    @Published var backgroundImageUrl: String?
    
    @MainActor
    func createBackgroundImage(image: UIImage?) {
        if let resultImage = image {
            resizeImage(image: resultImage)
        } else {
            guard !selectedPhotos.isEmpty else {
                return
            }
            Task {
                if let imageData = try? await selectedPhotos[0].loadTransferable(type: Data.self) {
                    if let image = UIImage(data: imageData) {
                        resizeImage(image: image)
                        return
                    }
                }
                backgroundImageUrl = ""
            }
        }
    }
    
    @MainActor
    func convertDataToImageFile() {
        createBackgroundImage(image: nil)
    }
    
    private func resizeImage(image: UIImage) {
        if let resizedImage = image.cropImage(toRect: CGRect(x: 0, y: 0, width: Dimensions.watchFaceWidth, height: Dimensions.watchFaceHeight)), let imageData = resizedImage.jpegData(compressionQuality: 0.7) {
            do {
                let imageFileName = UUID().uuidString + ".jpg"
                let imageFileUrl = FileManager.default.temporaryDirectory.appendingPathComponent(imageFileName)
                Logger.info("Image file URL: \(imageFileUrl)")
                try imageData.write(to: imageFileUrl)
                backgroundImageUrl = imageFileUrl.path()
            }
            catch {
                Logger.warning("Failed to save selected image to file!")
                backgroundImageUrl = ""
            }
        }
    }
}
