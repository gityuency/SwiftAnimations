//
//  YXPixModel.swift
//  Animations
//
//  Created by yuency on 07/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import Foundation
import UIKit

/// 像素点模型
class YXPixModel {
    
    /// 每个像素的颜色
    var color: UIColor = UIColor.brown
    
    /// 像素的 X 坐标 (整型)
    var pointX: Int = 0
    
    /// 像素的 Y 坐标 (整型)
    var pointY: Int = 0

    /// 每个像素延迟时间
    var delayTime: CGFloat = 0
    
    /// 每个像素持续时间
    var delayDuration: CGFloat = 0
    
    init() {
        delayTime = CGFloat(arc4random_uniform(30))
        delayDuration = CGFloat(arc4random_uniform(10))
    }
    
}

