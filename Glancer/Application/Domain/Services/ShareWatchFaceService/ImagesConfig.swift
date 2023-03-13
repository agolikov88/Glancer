//
//  ImagesConfig.swift
//  WatchCards
//
//  Created by Alexander Golikov on 12/5/21.
//  Copyright © 2021 Alexander Golikov. All rights reserved.
//

import Foundation

struct ImagesConfig: Encodable {
    
    var imageList: [ImageConfig] = []
    var version = 1
}

struct ImageConfig: Encodable {
    
    var bottomAnalysis = ImageAnalysis()
    var cropH = 480.0
    var cropW = 384.0
    var cropX = 0.0
    var cropY = 0.0
    var imageURL = ""
    var irisDuration = 0
    var irisStillDisplayTime = 0
    var irisVideoURL = ""
    var isIris = false
    var leftAnalysis = ImageAnalysis()
    var localIdentifier = UUID().uuidString
    var modificationDate = Date()
    var originalCropH = 480.0
    var originalCropW = 384.0
    var originalCropX = 0.0
    var originalCropY = 0.0
    var rightAnalysis = ImageAnalysis()
    var topAnalysis = ImageAnalysis()
}

struct ImageAnalysis: Encodable {
    
    var bgBrightness = 0.01183838304132223
    var bgHue = 0.0
    var bgSaturation = 0.0
    var coloredText = false
    var complexBackground = true
    var shadowBrightness = 0.02484404668211937
    var shadowHue = 0.0
    var shadowSaturation = 0.0
    var textBrightness = 0.01479797810316086
    var textHue = 0.0
    var textSaturation = 0.0
    var version = 1
}
