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
    
    /// 每个像素的颜色 (为优化性能,免去 UIColor 和 CGColor 转换)
    var cgColor: CGColor = UIColor.brown.cgColor
    
    /// 像素的 X 坐标
    var pointX: CGFloat = 0
    
    /// 像素的 Y 坐标
    var pointY: CGFloat = 0
    
    /// 每个像素延迟时间
    var delayTime: CGFloat = 0
    
    /// 每个像素持续时间
    var durationTime: CGFloat = 0
    
    /// 标记这个像素点是否已经到达目的地
    var isEnd = false
    
    /// 粒子总时间
    private(set) var allTime: CGFloat
    
    init() {
        
        delayTime = CGFloat(arc4random_uniform(30))
        
        //粒子的持续时间不能为0
        let time = CGFloat(arc4random_uniform(20))
        durationTime = time < 2 ? 2 : time
        
        allTime = delayTime + durationTime
    }
    
}


