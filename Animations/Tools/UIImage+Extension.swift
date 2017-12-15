//
//  UIImage+Extension.swift
//  Animations
//
//  Created by yuency on 15/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    /// 更改图片颜色 用颜色去渲染图片 获得新的图片
    public func imageWithTintColor(color : UIColor) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        color.setFill()
        let bounds = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(bounds)
        self.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
}
