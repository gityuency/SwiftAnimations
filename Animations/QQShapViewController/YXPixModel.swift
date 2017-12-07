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
    
    /// 每个像素的位置
    var point: CGPoint = CGPoint(x: 0, y: 0)
    
    /// 每个像素延迟时间
    var delayTime: CGFloat = 0
    
    /// 每个像素持续时间
    var delayDuration: CGFloat = 0
    
    init() {
        delayTime = CGFloat(arc4random_uniform(30))
        delayDuration = CGFloat(arc4random_uniform(10))
    }
    
}

