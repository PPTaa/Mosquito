//
//  UIView.swift
//  Mosquito
//
//  Created by leejungchul on 2023/03/13.
//

import UIKit

extension UIView {
    func shadowSetting(offset: CGSize = .zero, radius: CGFloat, color: UIColor, opacity: Float) {
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
    }
    
    func circleCorner() {
        self.layer.cornerRadius = self.frame.height / 2
    }
    

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    // get GlobalFrame Rect
    var globalFrame :CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
}

