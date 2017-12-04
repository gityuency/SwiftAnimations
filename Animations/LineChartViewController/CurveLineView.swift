//
//  CurveLineView.swift
//  成绩曲线图
//
//  Created by yuency on 30/11/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

/// 曲线分数图
class CurveLineView: UIView, CAAnimationDelegate{
    
    /// 获得最小的长度
    private var minLength: CGFloat {
        return self.frame.size.width > self.frame.size.height ? self.frame.size.height : self.frame.size.width;
    }
    
    /// 高度 44
    let height44: CGFloat = 44
    
    /// 背景层的高度
    var scoreHeight: CGFloat {
        return minLength - height44 * 2
    }
    
    /// 放曲线的背景
    lazy var backLayer: CALayer = {
        let bLayer = CALayer()
        bLayer.frame = CGRect(x: 0, y: height44, width: minLength, height: minLength - height44 * 2)
        layer.addSublayer(bLayer)
        return bLayer
    }()
    
    /// 线条
    var lineShapLayer: CAShapeLayer!
    
    /// 分数圆环数组
    var scrollViewArray: Array<UIView> = Array()
    
    /// 分数点数组
    var scorePointArray: Array<CALayer> = Array()
    
    
    var scoreArray: Array<CGFloat> = Array() {
        didSet{
            
            if scoreArray.count == 0 { assertionFailure("数组不能为空") }
            
            //先结束动画
            endAnimation()
            
            // 重新画视图
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.prepareForView()
            }
            
            //开始动画
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.startAnimation()
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func prepareForView() {
        
        // 计算最下面的 Label
        let width = minLength / CGFloat(scoreArray.count);
        
        for (i, _) in scoreArray.enumerated() {
            let label = UILabel(frame: CGRect(x: CGFloat(i) * width, y: minLength - height44, width: width, height: height44))
            label.text = "\(Int(i) + 1)"
            label.textColor = UIColor.black
            label.textAlignment = .center
            addSubview(label)
        }
        
        
        let pointWH: CGFloat = 10
        
        // 添加分数点
        for (i, score) in scoreArray.enumerated() {
            let pLayer = CALayer()
            pLayer.frame = CGRect(x: 0, y: 0, width: pointWH, height: pointWH)
            pLayer.cornerRadius = pointWH / 2
            pLayer.position = CGPoint(x: (width / 2) + CGFloat(i) * width, y: scoreHeight * (1.0 - score))
            pLayer.backgroundColor = UIColor.red.cgColor
            
            pLayer.opacity = 0
            
            backLayer.addSublayer(pLayer)
            
            scorePointArray.append(pLayer)
        }
        
        
        let pointArray = backLayer.sublayers!
        
        /// 画曲线条
        let linePath = UIBezierPath()
        linePath.lineWidth = 1.0
        linePath.lineCapStyle = .round
        linePath.lineJoinStyle = .round
        
        //重整数组,插入最开始和结束点
        let startPoint = CGPoint(x: 0, y: scoreHeight)
        
        var endPoint: CGPoint
        if pointArray.count == 1 {
            endPoint = needEndPoint(point1: pointArray[0].position, point2: pointArray[0].position)
        } else {
           endPoint = needEndPoint(point1: pointArray[pointArray.count - 2].position, point2: pointArray[pointArray.count - 1].position)
        }
        
        let pointsArray = pointArray.map { (layer) -> CGPoint in return layer.position }
        let newPointArray = [startPoint] + pointsArray + [endPoint]
        
        
        linePath.move(to: startPoint)
        
        // 画曲线
        for (i, point) in newPointArray.enumerated() {
            if i == 0 { continue }
            let controlPoint1 = newPointArray[i - 1]
            let controlPoint2 = newPointArray[i]
            linePath.addCurve(to: point, controlPoint1:  needCurvePoint1(point1: controlPoint1, point2: controlPoint2), controlPoint2: needCurvePoint2(point1: controlPoint1, point2: controlPoint2))
        }
        lineShapLayer = CAShapeLayer()
        lineShapLayer.path = linePath.cgPath
        lineShapLayer.fillColor = UIColor.clear.cgColor
        lineShapLayer.strokeColor = UIColor.purple.cgColor
        lineShapLayer.strokeStart = 0
        lineShapLayer.strokeEnd = 0
        backLayer.addSublayer(lineShapLayer)
        
        
        // 分数圆环 按钮
        let buttonWH: CGFloat = 34
        for (i, pointLayer) in pointArray.enumerated() {
            let scoreButton = UIButton()
            scoreButton.frame = CGRect(x: 0, y: 0, width: buttonWH, height: buttonWH)
            scoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            scoreButton.center = CGPoint(x: pointLayer.position.x, y: pointLayer.position.y + pointWH / 2 + buttonWH / 2 - 2)
            scoreButton.titleLabel?.textAlignment = .center
            scoreButton.layer.borderWidth = 2
            scoreButton.layer.borderColor = UIColor.magenta.cgColor
            scoreButton.setTitleColor(UIColor.red, for: .normal)
            
            if i < scoreArray.count {
                let ss = Int(scoreArray[i] * 100)
                scoreButton.setTitle("\(ss)", for: .normal)
                scoreButton.layer.cornerRadius = buttonWH / 2
                addSubview(scoreButton)
                scoreButton.alpha = 0
                scrollViewArray.append(scoreButton)
            }
        }
        
    }
    
    
    //MARK: 获取结束点
    func needEndPoint(point1: CGPoint, point2: CGPoint) -> CGPoint {
        if point1.y >= point2.y {
            return CGPoint(x: minLength, y: 0)
        } else {
            return CGPoint(x: minLength, y: scoreHeight)
        }
    }
    
    

    /// 拉伸的点
    private let offset: CGFloat = 10;

    //MARK: 获取第一个控制点
    func needCurvePoint1(point1: CGPoint, point2: CGPoint) -> CGPoint {
        let X = (point2.x - point1.x) / 2 + point1.x
        var Y: CGFloat = 0
        if point1.y != point2.y {
            Y = point1.y + offset
        } else {
            Y = point1.y
        }
        return CGPoint(x: X, y: Y)
    }
    
    
    //MARK: 获取第二个结束点
    func needCurvePoint2(point1: CGPoint, point2: CGPoint) -> CGPoint {
        let X = (point2.x - point1.x) / 2 + point1.x
        var Y: CGFloat = 0
        if point1.y != point2.y {
            Y = point2.y - offset
        } else {
            Y = point2.y
        }
        return CGPoint(x: X, y: Y)
    }
    
    /// 结束动画
    func endAnimation() {
        
        // 动画持续时间
        let duration: CFTimeInterval = 0.5
        
        //复位缓圆环
        for button in self.scrollViewArray {
            
            let animation = CABasicAnimation(keyPath: "position")
            animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
            animation.fromValue = button.center
            animation.toValue = CGPoint(x: button.center.x, y: button.center.y - 30)
            
            let alphaAni = CABasicAnimation(keyPath: "opacity")
            alphaAni.fromValue = 1
            alphaAni.toValue = 0
            button.alpha = 0
            
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = duration
            animationGroup.fillMode = kCAFillModeBoth
            animationGroup.animations = [animation, alphaAni]
            button.layer.add(animationGroup, forKey: nil)
        }
        
        //复位点
        for pointLayer in self.scorePointArray {
            
            let animation = CABasicAnimation(keyPath: "position")
            animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
            animation.fromValue = pointLayer.position
            animation.toValue = CGPoint(x: pointLayer.position.x, y: self.scoreHeight / 2)
            
            let alphaAni = CABasicAnimation(keyPath: "opacity")
            alphaAni.fromValue = 1
            alphaAni.toValue = 0
            pointLayer.opacity = 0
            
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = duration
            animationGroup.fillMode = kCAFillModeBoth
            animationGroup.animations = [animation, alphaAni]
            pointLayer.add(animationGroup, forKey: nil)
        }
        
        // 复位线条
        if lineShapLayer == nil { return }
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = duration
        animation.delegate = self
        animation.setValue("lineShapLayerAnimation", forKey: "AnimationKey")
        
        lineShapLayer.strokeStart = 0
        lineShapLayer.strokeEnd = 0
        lineShapLayer.add(animation, forKey: nil)
        
    }
    
    
    // MARK: 动画代理函数
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        if let a = anim.value(forKey: "AnimationKey"), let b = a as? String {
            if b == "lineShapLayerAnimation" {
                clearView()
            }
        }
    }
    
    
   private func clearView() {
        
        scrollViewArray.removeAll()
        scorePointArray.removeAll()
        
        self.backLayer.sublayers?.forEach({ (subLayer) in
            subLayer.removeFromSuperlayer()
        })
        
        self.subviews.forEach { (subView) in
            subView.removeFromSuperview()
        }
    }
    
    
    
    /// 开始动画
    func startAnimation() {   //动画持续时间 1.75秒
        
        let delay = DispatchTime.now()
        // 圆点动画
        DispatchQueue.main.asyncAfter(deadline: delay) {
            
            for pointLayer in self.scorePointArray {
                //位置
                let animation = CABasicAnimation(keyPath: "position")
                animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
                animation.fromValue = CGPoint(x: pointLayer.position.x, y: self.scoreHeight / 2)
                animation.toValue = pointLayer.position
                
                //透明度
                let alphaAni = CABasicAnimation(keyPath: "opacity")
                alphaAni.fromValue = 0
                alphaAni.toValue = 1
                pointLayer.opacity = 1
                
                let animationGroup = CAAnimationGroup()
                animationGroup.duration = 0.25
                animationGroup.fillMode = kCAFillModeBoth
                animationGroup.animations = [animation, alphaAni]
                pointLayer.add(animationGroup, forKey: nil)
            }
        }
        
        //画线动画
        DispatchQueue.main.asyncAfter(deadline: delay + 0.25) {
            //进度
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 1
            self.lineShapLayer.strokeStart = 0
            self.lineShapLayer.strokeEnd = 1;
            self.lineShapLayer.add(animation, forKey: nil)
        }
        
        //分数动画
        DispatchQueue.main.asyncAfter(deadline: delay + 0.25 + 1) {
            
            for button in self.scrollViewArray {
                //位置
                let animation = CABasicAnimation(keyPath: "position")
                animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
                animation.fromValue = CGPoint(x: button.center.x, y: button.center.y + 20)
                animation.toValue = button.center
                animation.isRemovedOnCompletion = false
                
                //透明度
                let alphaAni = CABasicAnimation(keyPath: "opacity")
                alphaAni.fromValue = 0
                alphaAni.toValue = 1
                button.alpha = 1
                
                let animationGroup = CAAnimationGroup()
                animationGroup.duration = 0.5
                animationGroup.fillMode = kCAFillModeBoth
                animationGroup.animations = [animation, alphaAni]
                button.layer.add(animationGroup, forKey: nil)
                
                
            }
        }
    }
}


/// 画二次曲线
//  linePath.addCurve(to: CGPoint(x: 200, y: 200), controlPoint1:  CGPoint(x: 150, y: 0), controlPoint2: CGPoint(x: 150, y: 100 + 100))
