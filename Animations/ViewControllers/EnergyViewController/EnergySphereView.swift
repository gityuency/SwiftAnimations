//
//  EnergySphereView.swift
//  水球动画
//
//  Created by yuency on 20/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

/// 能量球
class EnergySphereView: UIView {
    
    /// 进度
    var progress: CGFloat = 0 {
        didSet{
            startAnimate()
        }
    }
    
    /// 随机颜色数组
    lazy private var colorArray: Array<UIColor> = {
        return [
            UIColor.red,
            UIColor.green,
            UIColor.yellow,
            UIColor.magenta,
            UIColor.white,
            UIColor.purple,
            UIColor(red:1.00, green:0.76, blue:0.80, alpha:1.00),
            UIColor(red:0.73, green:0.35, blue:0.82, alpha:1.00),
            UIColor(red:0.99, green:0.27, blue:0.12, alpha:1.00),
            UIColor(red:0.69, green:0.99, blue:0.27, alpha:1.00),
            UIColor(red:0.16, green:0.57, blue:0.99, alpha:1.00),
            UIColor(red:0.80, green:0.80, blue:0.99, alpha:1.00),
            UIColor(red:0.93, green:0.52, blue:0.93, alpha:1.00),
            UIColor(red:0.87, green:0.72, blue:0.54, alpha:1.00),
            UIColor(red:0.82, green:0.41, blue:0.17, alpha:1.00),
            UIColor(red:1.00, green:0.84, blue:0.19, alpha:1.00),
            UIColor(red:0.61, green:0.96, blue:0.61, alpha:1.00),
            ]
    }()
    
    
    /// 获得最小的长度
    private var minLength: CGFloat {
        return self.frame.size.width > self.frame.size.height ? self.frame.size.height : self.frame.size.width;
    }
    
    /// 半径 R
    private var R: CGFloat {
        return (minLength / 2) * 0.9
    }
    
    
    deinit {
        printLog("能量球毁灭")
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    /// 明环
    private let lightCirlceLayer = CAShapeLayer()
    /// 暗环
    let darkCirlceLayer = CAShapeLayer()
    
    /// 波浪
    private var wave: XLWave?
    
    /// 设置 View
    private func setUpView() {
        
        // 波浪
        wave = XLWave(frame: CGRect(x: 0, y: 0, width: R * 2, height: R * 2))
        wave?.center = center
        wave?.backgroundColor = UIColor.clear
        wave?.progress = progress
        addSubview(wave!)
        
        //暗环
        darkCirlceLayer.frame = bounds
        layer.addSublayer(darkCirlceLayer)
        
        //暗环路径
        let darkCirlcePath = UIBezierPath(arcCenter: center, radius: R, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        darkCirlceLayer.path = darkCirlcePath.cgPath
        darkCirlceLayer.strokeColor = UIColor.orange.cgColor
        darkCirlceLayer.fillColor = UIColor.clear.cgColor
        darkCirlceLayer.lineWidth = 5
        
        //明环
        lightCirlceLayer.frame = bounds
        layer.addSublayer(lightCirlceLayer)
        
        //明环路径
        let lightCirlcePath = UIBezierPath(arcCenter: center, radius: R, startAngle: -CGFloat.pi * (1 / 2), endAngle: CGFloat.pi + CGFloat.pi * (1 / 2), clockwise: true)
        //let lightCirlcePath = UIBezierPath(arcCenter: center, radius: R, startAngle: -CGFloat.pi * (1 / 2), endAngle: CGFloat.pi, clockwise: true)
        lightCirlceLayer.path = lightCirlcePath.cgPath
        lightCirlceLayer.strokeColor = UIColor.black.cgColor
        lightCirlceLayer.fillColor = UIColor.clear.cgColor
        lightCirlceLayer.lineWidth = 10
        
        //开始动画
        startAnimate()
    }
    
    /// 开始动画
    func startAnimate() {
        
        
        let lightColor = needColor()
        
        //圆环变色
        let animation = CABasicAnimation(keyPath: "strokeColor")
        animation.fromValue = lightCirlceLayer.strokeColor
        animation.toValue = lightColor
        lightCirlceLayer.strokeColor = lightColor
        
        // 圆环进度
        let keyAnimation = CAKeyframeAnimation(keyPath: "strokeEnd")
        keyAnimation.values = calculateFrameFromValue(fromValue: lightCirlceLayer.strokeEnd, toValue: progress, function: ExponentialEaseOut, frameCount: 2 * 30)
        lightCirlceLayer.strokeEnd = progress
        
        // 动画组
        let animaGroup = CAAnimationGroup()
        animaGroup.duration = 2
        animaGroup.animations = [animation, keyAnimation]
        animation.fillMode = CAMediaTimingFillMode.both
        lightCirlceLayer.add(animaGroup, forKey: nil)
        
        
        let darkColor = needColor()
        
        //暗环变色
        let animationDark = CABasicAnimation(keyPath: "strokeColor")
        animationDark.duration = 1
        animationDark.fromValue = lightCirlceLayer.strokeColor
        animationDark.toValue = darkColor
        darkCirlceLayer.strokeColor = darkColor
        darkCirlceLayer.add(animationDark, forKey: nil)
        
        ///更新数据
        wave?.progress = progress
        
    }
    
    
    
    /// 获得随机颜色
    private func needColor() -> CGColor {
        //获得随机色
        let random = Int(arc4random_uniform(UInt32(colorArray.count)))
        let randomColor = colorArray[random].cgColor
        return randomColor
    }
    
}


//animation.isRemovedOnCompletion = false
//lightCirlceLayer.strokeEnd = progress    // 这句话要写在添加动画之前
//lightCirlceLayer.lineCap = kCALineCapRound


/*
 
 let lary = CATextLayer()
 
 
 
 lary.string = "0"
 lary.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
 lary.position = center
 lary.font = "HiraKakuProN-W3" as CFTypeRef;//字体的名字 不是 UIFont
 lary.fontSize = 80;//字体的大小
 lary.isWrapped = true;//默认为No.  当Yes时，字符串自动适应layer的bounds大小
 lary.alignmentMode = kCAAlignmentNatural;//字体的对齐方式
 lary.contentsScale = UIScreen.main.scale//解决文字模糊 以Retina方式来渲染，防止画出来的文本像素化
 lary.backgroundColor = UIColor.yellow.cgColor
 lary.foregroundColor =[UIColor redColor].CGColor;//字体的颜色 文本颜色
 layer.addSublayer(lary)
 
 
 
 //文字变化
 let textAnimation = CAKeyframeAnimation(keyPath: "string")
 textAnimation.duration = 2
 // 计算得出数值是 CGFloat 类型
 guard let one = lary.string as? String,  let two = Double(one) else {
 return
 }
 let from = CGFloat(two)
 let to = progress * 100
 let floatArray = calculateFrameFromValue(fromValue: from, toValue: to, function: QuadraticEaseOut, frameCount: 2 * 30)
 
 var textArray = floatArray.map { (value) -> String in
 return "\(Int(value))"
 }
 
 textArray.insert("\(Int(to))", at: floatArray.count)
 
 print("数组 \(textArray)")
 
 textAnimation.values = textArray
 
 lary.string = textArray.last
 
 lary.add(textAnimation, forKey: nil)
 */





