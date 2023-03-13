//
//  UIImage+Watermark.swift
//  WatchCards
//
//  Created by Alexander Golikov on 6/24/20.
//  Copyright © 2020 Alexander Golikov. All rights reserved.
//

import Foundation
import UIKit

extension UIImage
{
    
    func waterMarkedImage(text: String, margin: CGPoint = CGPoint(x: 20, y: 20), font: String = "Avenir Next Condensed Regular", background: UIColor = UIColor.clear) -> UIImage?
    {
        let defaultWatchScreenWidth: CGFloat = 396
        
        let imageSize = self.size
        
        UIGraphicsBeginImageContext(imageSize)
        self.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        
        let textView = UITextView()
        textView.text = text
        textView.textColor = UIColor.white
        textView.font = UIFont(name: font.isEmpty ? "Avenir Next Condensed Regular" : font, size: 40)
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
