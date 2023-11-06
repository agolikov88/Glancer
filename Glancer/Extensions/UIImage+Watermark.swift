//
//  UIImage+Watermark.swift
//  WatchCards
//
//  Created by Alexander Golikov on 6/24/20.
//  Copyright © 2020 Alexander Golikov. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

extension UIImage
{
    
    func waterMarkedImage(text: String, margin: CGPoint = CGPoint(x: 24, y: 24), color: String = "FFFFFF", font: String = "AvenirNextCondensed-Medium", overlay: Bool = true) -> UIImage?
    {
        let defaultWatchScreenWidth: CGFloat = 396
        
        let imageSize = self.size
        
        //test parcial overlay...
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.bounds = CGRect(x: 0, y: 180, width: imageSize.width, height: 304)
//        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(0.3).cgColor, UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.black.withAlphaComponent(0.6).cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
//        gradientLayer.locations = [0.1, 0.2, 0.3, 0.7, 1]
//        gradientLayer.opacity = 1
        
        UIGraphicsBeginImageContext(imageSize)
        self.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        
        //test full overlay...
        if overlay {
            let gradientLayer = CALayer()
            gradientLayer.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
            gradientLayer.backgroundColor = UIColor.black.cgColor
            gradientLayer.opacity = 0.4
            gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        }
        
        let textView = UITextView()
        textView.text = text
        textView.textColor = UIColor(Color(hex: color) ?? Color.white)
        textView.font = UIFont(name: font.isEmpty ? "AvenirNextCondensed-Medium" : font, size: 40)
        var textHeight = text.height(withConstrainedWidth: defaultWatchScreenWidth - margin.x*2, font: textView.font!)

        textView.frame = CGRect(x: margin.x, y: 200 + margin.y, width: defaultWatchScreenWidth - margin.x*2, height: 284 - margin.y*2)
        
        if (textHeight > textView.frame.size.height) {
            var fontIncrement = 1;
            while (textHeight > textView.frame.size.height) {
                textView.font = UIFont(name: font, size: CGFloat((40 - fontIncrement)))
                textHeight = text.height(withConstrainedWidth: defaultWatchScreenWidth - margin.x*2, font: textView.font!)
                fontIncrement += 1
            }
        }
        
        textView.text.draw(in: textView.frame, withAttributes:[NSAttributedString.Key.font: textView.font!, NSAttributedString.Key.foregroundColor: textView.textColor!])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }    
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}
