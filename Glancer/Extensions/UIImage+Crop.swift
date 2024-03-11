//
//  UIImage+Crop.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 3/10/24.
//

import Foundation
import UIKit

extension UIImage {
    
    func cropImage(toRect cropRect: CGRect) -> UIImage? {
        var scaledWidth: CGFloat
        var scaledHeight: CGFloat
        
        if self.size.width >= self.size.height {
            scaledHeight = cropRect.height
            scaledWidth = self.size.width * (scaledHeight / self.size.height)
        } else {
            scaledWidth = cropRect.width
            scaledHeight = self.size.height * (scaledWidth / self.size.width)
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: scaledWidth, height: scaledHeight), true, 1.0)
        self.draw(in: CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight))
        let scaledImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cropImage = scaledImage else {
            return nil
        }
        
        var cropZone: CGRect
        
        if cropImage.size.width >= cropImage.size.height {
            cropZone = CGRect(x: Int((cropImage.size.width - cropRect.width)/2),
                              y:0,
                              width:Int(cropRect.width),
                              height:Int(cropRect.height))
        } else {
            cropZone = CGRect(x: 0,
                              y: Int((cropImage.size.height - cropRect.height)/2),
                              width:Int(cropRect.width),
                              height:Int(cropRect.height))
        }
        guard let cutImageRef = cropImage.cgImage?.cropping(to: cropZone) else {
            return nil
        }
        
        return UIImage(cgImage: cutImageRef)
    }
}
