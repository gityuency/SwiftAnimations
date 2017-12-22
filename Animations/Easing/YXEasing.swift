//
//  YXEasing.swift
//  水球动画
//
//  Created by yuency on 21/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import Foundation
import UIKit

//缓动函数速查表
//http://www.xuanfengge.com/easeing/easeing/#

/// 弧度转角度
func RADIANS_TO_DEGREES(radians: CGFloat) -> CGFloat {
    return radians * (180.0 / CGFloat.pi)
}

/// 角度转弧度
func DEGREES_TO_RADIANS(angle: CGFloat) -> CGFloat {
    return angle / (180.0 * CGFloat.pi)
}


/*---------------------------------------------
 
 -动画简单的解析-
 
 BackEase        ：在某一动画开始沿指示的路径进行动画处理前稍稍收回该动画的移动。
 BounceEase      ：创建弹跳效果。
 CircleEase      ：创建使用循环函数加速和/或减速的动画。
 CubicEase       ：创建使用公式 f(t) = t^3 加速和/或减速的动画。
 ElasticEase     ：创建类似于弹簧在停止前来回振荡的动画。
 ExponentialEase ：创建使用指数公式加速和/或减速的动画。
 PowerEase       ：创建使用公式 f(t) = t^p（其中，p 等于 Power 属性）加速和/或减速的动画。
 QuadraticEase   ：创建使用公式 f(t) = t^2 加速和/或减速的动画。
 QuarticEase     ：创建使用公式 f(t) = t^4 加速和/或减速的动画。
 QuinticEase     ：创建使用公式 f(t) = t^5 加速和/或减速的动画。
 SineEase        ：创建使用正弦公式加速和/或减速的动画。
 
 LinearInterpolation
 
 QuadraticEaseIn
 QuadraticEaseOut
 QuadraticEaseInOut
 
 CubicEaseIn
 CubicEaseOut
 CubicEaseInOut
 
 QuarticEaseIn
 QuarticEaseOut
 QuarticEaseInOut
 
 QuinticEaseIn
 QuinticEaseOut
 QuinticEaseInOut
 
 SineEaseIn
 SineEaseOut
 SineEaseInOut
 
 CircularEaseIn
 CircularEaseOut
 CircularEaseInOut
 
 ExponentialEaseIn
 ExponentialEaseOut
 ExponentialEaseInOut
 
 ElasticEaseIn
 ElasticEaseOut
 ElasticEaseInOut
 
 BackEaseIn
 BackEaseOut
 BackEaseInOut
 
 BounceEaseIn
 BounceEaseOut
 BounceEaseInOut
 ---------------------------------------------*/

/*
 // 计算好起始值,结束值
 CGFloat oldValue = 0.f;
 CGFloat newValue = 1.f;
 
 // 关键帧动画
 CAKeyframeAnimation *animation = \
 [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
 
 // 设置值
 [animation setValues:[YXEasing calculateFrameFromValue:oldValue
 toValue:newValue
 func:ElasticEaseOut
 frameCount:500]];
 
 // 设置持续时间
 animation.duration  = 0.5f;
 
 // 每秒增加的角度(设定结果值,在提交动画之前执行)
 layer.transform = \
 CATransform3DMakeRotation(newValue, 0.0, 0.0, 1.0);
 
 // 提交动画
 [layer addAnimation:animation forKey:nil];
 
 */


/// YXEasing 数组中存储的数据为 CGFloat 型
func calculateFrameFromValue(fromValue: CGFloat, toValue: CGFloat, function: (Double) -> (Double), frameCount: Int ) -> [CGFloat] {
    
    // 设置帧数量
    var values = Array<CGFloat>()
    
    // 计算并存储
    var t: Double = 0.0
    
    let dt = 1.0 / Double((frameCount - 1))
    
    let distance = toValue - fromValue
    
    for _ in 0..<frameCount {
        
        // 此处就会根据不同的函数计算出不同的值达到不同的效果
        let value = fromValue + CGFloat(function(t)) * distance
        
        // 将计算结果存储进数组中
        values.append(value)
        
        
        t += dt
    }
    
    // 数组中存储的数据为 CGFloat 型
    return values;
}



/// YXEasing 数组中存储的数据为  CGPoint 型
func calculateFrameFromPoint(fromPoint: CGPoint, toPoint: CGPoint, function: (Double) -> (Double), frameCount: Int ) -> [CGPoint] {
    
    // 设置帧数量
    var values = Array<CGPoint>()
    
    // 计算并存储
    var t: Double = 0.0
    
    let dt = 1.0 / Double((frameCount - 1))
    
    let distanceX = toPoint.x - fromPoint.x
    let distanceY = toPoint.y - fromPoint.y
    
    
    for _ in 0..<frameCount {
        
        let x = fromPoint.x + CGFloat(function(t)) * distanceX
        let y = fromPoint.y + CGFloat(function(t)) * distanceY
        
        values.append(CGPoint(x: x, y: y))
        
        t += dt
    }
    // 数组中存储的数据为 CGPoint 型
    return values
}

/// YXEasing 数组中存储的数据为  CGSize 型
func calculateFrameFromSize(fromSize: CGSize, toSize: CGSize, function: (Double) -> (Double), frameCount: Int ) -> [CGSize] {
    
    // 设置帧数量
    var values = Array<CGSize>()

    // 计算并存储
    var t: Double = 0.0
    
    let dt = 1.0 / Double((frameCount - 1))
    
    let width = toSize.width - fromSize.width
    let height = toSize.height - fromSize.height
    
    for _ in 0..<frameCount {
        
        let w = fromSize.width + CGFloat(function(t)) * width
        
        let h = fromSize.height + CGFloat(function(t)) * height
        
        values.append(CGSize(width: w, height: h))
        
        t += dt
    }
    
    // 数组中存储的数据为 CGSize 型
    return values
}



