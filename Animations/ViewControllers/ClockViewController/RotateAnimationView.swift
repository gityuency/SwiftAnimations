//
//  RotateAnimationView.swift
//  clock
//
//  Created by yuency on 2018/11/9.
//  Copyright © 2018年 yuency. All rights reserved.
//

import UIKit

class RotateAnimationView: UIView {
    
    /// 指针枚举
    enum RotatePointerType {
        case secPointer
        case minPointer
        case hourPointer
    }
    
    /// 动画时长 默认 1 秒
    var duration: TimeInterval = 1
    
    /// 旋转开始的角度 默认 0°
    var fromCircleRadian: CGFloat = 0
    
    ///旋转结束的角度 默认 360°
    var toCircleRadian: CGFloat = CGFloat.pi
    
    /// 指针类型 时分秒
    private var pointType: RotatePointerType!
    
    /// 指针长度 默认 100
    private var pointerLength: CGFloat = 100
    
    // 普通旋转动画 用于时针,分针
    private let normalRotateAni = CABasicAnimation(keyPath: "transform.rotation.z")
    
    // 缓动函数旋转动画 用于A 秒针
    private let easingRotateAni = CAKeyframeAnimation(keyPath: "transform.rotation.z")
    
    deinit {
        printLog("旋转视图销毁")
    }
        
    /// 初始化一个普通的旋转视图
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 初始化指针的构造方法
    init(pointType: RotatePointerType, pointerLength: CGFloat) {
        
        self.pointType = pointType
        self.pointerLength = pointerLength
        
        super.init(frame: CGRect.zero);
        
        //抗锯齿 旋转之后会产生锯齿
        layer.shouldRasterize = true;
        layer.allowsEdgeAntialiasing = true;
        
        
        layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        fromCircleRadian = 0
        toCircleRadian = 0
        
        switch pointType {
        case .secPointer:
            
            frame = CGRect(x: 0, y: 0, width: 4, height: pointerLength);
            backgroundColor = UIColor.red
            
            // 秒针呼吸
            glowRadius            = 5
            glowOpacity           = 0.95
            glowColor             = UIColor.yellow
            hideDuration          = 0.75
            glowAnimationDuration = 1.5
            glowDuration          = 1
            createGlowLayer()
            insertGlowLayer()
            startGlowLoop()
            
        case .minPointer:
            frame = CGRect(x: 0, y: 0, width: 7, height: pointerLength);
            backgroundColor = UIColor.green;
        case .hourPointer:
            frame = CGRect(x: 0, y: 0, width: 10, height: pointerLength);
            backgroundColor = UIColor.black;
        }        
    }
    
    /// 开始动画
    func startRotateAnimated(_ animated: Bool) {
        
        if animated {
            
            switch pointType! {
                
            case .secPointer:
                
                easingRotateAni.duration = duration
                easingRotateAni.values = calculateFrameFromValue(fromValue: fromCircleRadian, toValue: toCircleRadian, function: ElasticEaseOut, frameCount: Int(duration * 60))
                layer.transform = CATransform3DMakeRotation(toCircleRadian, 0, 0, 1); //为了不让视图旋转完之后跑回去
                layer.add(easingRotateAni, forKey: "esay")
                
            case .hourPointer, .minPointer:
                
                normalRotateAni.fromValue = fromCircleRadian
                normalRotateAni.toValue = toCircleRadian
                normalRotateAni.duration = duration
                layer.transform = CATransform3DMakeRotation(toCircleRadian, 0, 0, 1) //为了不让视图旋转完之后跑回去
                layer.add(normalRotateAni, forKey: "normal")
            }
            
        } else {
            layer.transform = CATransform3DMakeRotation(toCircleRadian, 0, 0, 1)
        }
    }
}
