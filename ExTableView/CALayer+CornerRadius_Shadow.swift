//
//  CALayer+CornerRadius_Shadow.swift
//  erp_ios
//
//  Created by Hungry on 2019/4/22.
//  Copyright © 2019 Rex Peng. All rights reserved.
//

import UIKit

struct Constants {
    static var contentLayerName = "layer"
    static var borderLayer = "borderLayer"
}

extension CALayer {
    private func addShadowWithRoundedCorners() {
        if let contents = self.contents {
            masksToBounds = false
            sublayers?.filter{ $0.frame.equalTo(self.bounds) }
                .forEach{ $0.roundCorners(radius: self.cornerRadius) }
            self.contents = nil
            if let sublayer = sublayers?.first,
                sublayer.name == Constants.contentLayerName {
                
                sublayer.removeFromSuperlayer()
            }
            let contentLayer = CALayer()
            contentLayer.name = Constants.contentLayerName
            contentLayer.contents = contents
            contentLayer.frame = bounds
            contentLayer.cornerRadius = cornerRadius
            contentLayer.masksToBounds = true
            insertSublayer(contentLayer, at: 0)
        }
    }
    
    func addShadow(offset: CGSize, opacity: Float, redius: CGFloat, color: UIColor = .black) {
        self.shadowOffset = offset
        self.shadowOpacity = opacity
        self.shadowRadius = redius
        self.shadowColor = color.cgColor
        self.masksToBounds = false
        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }
    func roundCorners(radius: CGFloat) {
        self.cornerRadius = radius
        if shadowOpacity != 0 {
            addShadowWithRoundedCorners()
        }
    }
}
