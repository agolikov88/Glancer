//
//  PagerIndicator.swift
//  Glancer
//
//  Created by Alexander Golikov on 5/29/23.
//

import UIKit
import SwiftUI

struct PagerIndicator: UIViewRepresentable {
    
    var currentPage = 0
    var pagesNumber = 0
    
    func makeUIView(context: Context) -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.numberOfPages = pagesNumber
        
        return pageControl
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.numberOfPages = pagesNumber
        uiView.currentPage = currentPage
    }
}
