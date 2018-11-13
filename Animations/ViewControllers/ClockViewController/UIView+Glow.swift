//
//  UIView+Glow.swift
//  clock
//
//  Created by yuency on 2018/11/12.
//  Copyright © 2018年 yuency. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    //
    //                                     == 动画时间解析 ==
    //
    //  0.0 ------------- 0.0 ------------> glowOpacity [-------------] glowOpacity ------------> 0.0
    //           T                 T                           T                          T
    //           |                 |                           |                          |
    //           |                 |                           |                          |
    //           .                 .                           .                          .
    //     hideDuration  glowAnimationDuration           glowDuration            glowAnimationDuration
    //
    
    
    /// Swift Runtime 属性定义的 Key
    private struct RuntimeKey {
        
        static let glowColorKey = UnsafeRawPointer.init(bitPattern: "glowColorKey".hashValue)!
        static let glowOpacityKey =  UnsafeRawPointer.init(bitPattern: "glowOpacityKey".hashValue)!
        static let glowAnimationDurationKey = UnsafeRawPointer.init(bitPattern: "glowAnimationDurationKey".hashValue)!
        static let glowRadiusKey = UnsafeRawPointer.init(bitPattern: "glowRadiusKey".hashValue)!
        static let glowDurationKey = UnsafeRawPointer.init(bitPattern: "glowDurationKey".hashValue)!
        static let hideDurationKey = UnsafeRawPointer.init(bitPattern: "hideDurationKey".hashValue)!
        static let glowLayerKey = UnsafeRawPointer.init(bitPattern: "glowLayerKey".hashValue)!
        static let dispatchSourcezKey = UnsafeRawPointer.init(bitPattern: "dispatchSourcezKey".hashValue)!
    }
    
    /// 定时器
    private var dispatchSource: DispatchSourceTimer? {
        set {
            objc_setAssociatedObject(self, UIView.RuntimeKey.dispatchSourcezKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UIView.RuntimeKey.dispatchSourcezKey) as? DispatchSourceTimer
        }
    }
    
    /// 辉光层
    private var glowLayer: CALayer? {
        set {
            objc_setAssociatedObject(self, UIView.RuntimeKey.glowLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UIView.RuntimeKey.glowLayerKey) as? CALayer
        }
    }
    
    /// 辉光的颜色
    var glowColor: UIColor? {  //这种关联的属性要设置为可选属性, 类型最好使用 retain, 否则会有奇妙的崩溃
        set {
            objc_setAssociatedObject(self, UIView.RuntimeKey.glowColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UIView.RuntimeKey.glowColorKey) as? UIColor
        }
    }
    
    /// 辉光的透明度
    var glowOpacity: Float? {
        set {
            objc_setAssociatedObject(self, UIView.RuntimeKey.glowOpacityKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UIView.RuntimeKey.glowOpacityKey) as? Float
        }
    }
    
    /// 辉光的阴影半径
    var glowRadius: Double? {
        set {
            objc_setAssociatedObject(self, UIView.RuntimeKey.glowRadiusKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UIView.RuntimeKey.glowRadiusKey) as? Double
        }
    }
    
    ///  一次完整的辉光周期（从显示到透明或者从透明到显示），默认1s
    var glowAnimationDuration: CFTimeInterval? {
        set {
            objc_setAssociatedObject(self, UIView.RuntimeKey.glowAnimationDurationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UIView.RuntimeKey.glowAnimationDurationKey) as? CFTimeInterval
        }
    }
    
    /// 保持辉光时间（不设置，默认为0.5s）
    var glowDuration: Double? {
        set {
            objc_setAssociatedObject(self, UIView.RuntimeKey.glowDurationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UIView.RuntimeKey.glowDurationKey) as? Double
        }
    }
    
    /// 不显示辉光的周期（不设置默认为0.5s）
    var hideDuration: Double? {
        set {
            objc_setAssociatedObject(self, UIView.RuntimeKey.hideDurationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UIView.RuntimeKey.hideDurationKey) as? Double
        }
    }
    
    /// 创建出辉光layer
    func createGlowLayer() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale);
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let path = UIBezierPath(rect: bounds)
        accessGlowColor().setFill()
        path.fill(with: .sourceAtop, alpha: 1)  //这个就是类似于安卓里面的两个图片相交的算法
        glowLayer = CALayer()
        glowLayer?.frame = bounds
        glowLayer?.contents = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        glowLayer?.opacity = 0
        glowLayer?.shadowOffset = CGSize(width: 0, height: 0)
        glowLayer?.shadowOpacity = 1
        UIGraphicsEndImageContext();
    }
    
    /// 插入辉光的layer
    func insertGlowLayer() {
        if let glowLayer = glowLayer {
            layer.addSublayer(glowLayer)
        }
    }
    
    /// 移除辉光的layer
    func removeGlowLayer() {
        if let glowLayer = glowLayer {
            glowLayer.removeFromSuperlayer()
        }
    }
    
    /// 显示辉光
    func glowToshowAnimated(animated: Bool) {
        if let glowLayer = glowLayer {
            glowLayer.shadowColor = accessGlowColor().cgColor
            glowLayer.shadowRadius = CGFloat(accessGlowRadius())
            if animated {
                let animation = CABasicAnimation(keyPath: "opacity")
                animation.fromValue = 0
                animation.toValue = accessGlowOpacity()
                animation.duration = accessAnimationDuration()
                glowLayer.opacity = accessGlowOpacity()
                glowLayer.add(animation, forKey: "glowLayerOpacity")
            } else {
                glowLayer.removeAnimation(forKey: "glowLayerOpacity")
                glowLayer.opacity = accessGlowOpacity()
            }
        }
    }
    
    /// 隐藏辉光
    func glowToHideAnimated(animated: Bool) {
        if let glowLayer = glowLayer {
            glowLayer.shadowColor = accessGlowColor().cgColor
            glowLayer.shadowRadius = CGFloat(accessGlowRadius())
            if animated {
                let animation = CABasicAnimation(keyPath: "opacity")
                animation.fromValue = accessGlowOpacity()
                animation.toValue = 0
                animation.duration = accessAnimationDuration()
                glowLayer.opacity = 0
                glowLayer.add(animation, forKey: "glowLayerOpacity")
            } else {
                glowLayer.removeAnimation(forKey: "glowLayerOpacity")
                glowLayer.opacity = 0
            }
        }
    }
    
    /// 开始循环辉光
    func startGlowLoop() {
        if dispatchSource == nil {
            //隐藏时间 + 变亮时间 + 持续时间 + 变暗时间
            let seconds = accessAnimationDuration() * 2 + accessHideDuration() + accessHideDuration()
            // 后半段动画的开始时间 (持续时间 + 变暗时间)
            let delayOffset = accessAnimationDuration() + accessGlowDuration()
            dispatchSource = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
            dispatchSource?.schedule(deadline: .now(), repeating: seconds)
            dispatchSource?.setEventHandler(handler: { [weak self] in
                self?.glowToshowAnimated(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + delayOffset, execute: {
                    self?.glowToHideAnimated(animated: true)
                })
            })
            dispatchSource?.resume()
        }
    }
    
    //MARK: - 数据越界处理
    private func accessAnimationDuration() -> CFTimeInterval {
        if let glowAnimationDuration = glowAnimationDuration, glowAnimationDuration > 0 {
            return glowAnimationDuration
        } else {
            return 1
        }
    }
    
    private  func accessGlowDuration() -> Double {
        if let glowDuration = glowDuration, glowDuration > 0 {
            return glowDuration
        } else {
            return 0.5
        }
    }
    
    private func accessHideDuration() -> Double {
        if let hideDuration = hideDuration, hideDuration > 0 {
            return hideDuration
        } else {
            return 0.5
        }
    }
    
    private func accessGlowOpacity() -> Float {
        if let glowOpacity = glowOpacity {
            return glowOpacity
        } else {
            return 0.8
        }
    }
    
    private func accessGlowRadius() -> Double {
        if let glowRadius = glowRadius, glowRadius > 0 {
            return glowRadius
        } else {
            return 2
        }
    }
    
    private func accessGlowColor() -> UIColor {
        if let glowColor = glowColor {
            return glowColor
        } else {
            return UIColor.red
        }
    }
}

