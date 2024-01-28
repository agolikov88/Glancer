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
    func convertDataToImageFile() {
        guard !selectedPhotos.isEmpty else {
            return
        }
        Task {
            if let imageData = try? await selectedPhotos[0].loadTransferable(type: Data.self) {
                // test...
                if let image = UIImage(data: imageData) {
                    if let resizedImage = cropImage(image, toRect: CGRect(x: 0, y: 0, width: 396, height: 484), viewWidth: 396, viewHeight: 484), let imageData = resizedImage.jpegData(compressionQuality: 0.7) {
                        do {
                            let imageFileName = UUID().uuidString + ".jpg"
                            let imageFileUrl = FileManager.default.temporaryDirectory.appendingPathComponent(imageFileName)
                            Logger.info("Image file URL: \(imageFileUrl)")
                            try imageData.write(to: imageFileUrl)
                            backgroundImageUrl = imageFileUrl.path()
                            return
                        }
                        catch {
                            Logger.warning("Failed to save selected image to file!")
                        }
                    }
                }
            }
            backgroundImageUrl = ""
        }
    }
    
    // test...
    func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage?
    {
        var scaledWidth: CGFloat
        var scaledHeight: CGFloat
        
        if inputImage.size.width >= inputImage.size.height {
            scaledHeight = 484  // use viewWidth argument...
            scaledWidth = inputImage.size.width * (scaledHeight / inputImage.size.height)
        } else {
            scaledWidth = 396
            scaledHeight = inputImage.size.height * (scaledWidth / inputImage.size.width)
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: scaledWidth, height: scaledHeight), true, 1.0)
        inputImage.draw(in: CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight))
        let scaledImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cropImage = scaledImage else {
            return nil
        }
        
        var cropZone: CGRect
        
        // TODO: optimize...
        if cropImage.size.width >= cropImage.size.height {
            cropZone = CGRect(x: Int((cropImage.size.width - 396)/2),
                              y:0,
                              width:396,
                              height:484)
        } else {
            cropZone = CGRect(x: 0,
                              y: Int((cropImage.size.height - 484)/2),
                              width:396,
                              height:484)
        }
        guard let cutImageRef = cropImage.cgImage?.cropping(to: cropZone) else {
            return nil
        }
        
        return UIImage(cgImage: cutImageRef)
        
//        let imageViewScale = max(inputImage.size.width / viewWidth,
//                                 inputImage.size.height / viewHeight)
//        
//        
//        // Scale cropRect to handle images larger than shown-on-screen size
//        let cropZone = CGRect(x:cropRect.origin.x * imageViewScale,
//                              y:cropRect.origin.y * imageViewScale,
//                              width:cropRect.size.width * imageViewScale,
//                              height:cropRect.size.height * imageViewScale)
//        
//        
//        // Perform cropping in Core Graphics
//        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
//        else {
//            return nil
//        }
//        
//        
//        // Return image to UIImage
//        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
//        return croppedImage
    }
}
