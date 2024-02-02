//
//  CGRect+Extension.swift
//  TechDemo
//
//  Created by Rostyslav Dovhaliuk on 07.02.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

extension CGRect {
    static func makeRectFill(originalSize: CGSize, fillingSize: CGSize) -> CGRect {
        let aspectWidth = fillingSize.width / originalSize.width
        let aspectHeight = fillingSize.height / originalSize.height
        let aspectRatio = max(aspectWidth, aspectHeight)
        
        let newWidth = originalSize.width * aspectRatio
        let newHeight = originalSize.height * aspectRatio
        
        return CGRect(x: fillingSize.width - newWidth,
                      y: fillingSize.height - newHeight,
                      width: newWidth,
                      height: newHeight)
    }
    
    static func makeRectFit(originalSize: CGSize, fittingSize: CGSize) -> CGRect {
        let aspectWidth = fittingSize.width / originalSize.width
        let aspectHeight = fittingSize.height / originalSize.height
        let aspectRatio = min(aspectWidth, aspectHeight)
        
        let newWidth = originalSize.width * aspectRatio
        let newHeight = originalSize.height * aspectRatio
        
        return CGRect(x: fittingSize.width - newWidth,
                      y: fittingSize.height - newHeight,
                      width: newWidth,
                      height: newHeight)
    }
}

