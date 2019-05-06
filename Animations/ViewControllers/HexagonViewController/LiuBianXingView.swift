//
//  LiuBianXingView.swift
//  六边形 啦啦啦, 啦啦啦, 啦啦啦....
//
//  Created by yuency on 29/11/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

class LiuBianXingView: UIView {
    
    /// 外边框线条
    /// 线条 1
    private var border1: CAShapeLayer?
    /// 线条 2
    private var border2: CAShapeLayer?
    /// 线条 3
    private var border3: CAShapeLayer?
    /// 线条 4
    private var border4: CAShapeLayer?
    /// 线条 5
    private var border5: CAShapeLayer?
    /// 线条 6
    private var border6: CAShapeLayer?
    
    private var lineArray: Array<CAShapeLayer> = Array()
    
    
    /// 内边框线条
    /// 线条 1
    private var innerLine1: CAShapeLayer?
    /// 线条 2
    private var innerLine2: CAShapeLayer?
    /// 线条 3
    private var innerLine3: CAShapeLayer?
    /// 线条 4
    private var innerLine4: CAShapeLayer?
    /// 线条 5
    private var innerLine5: CAShapeLayer?
    /// 线条 6
    private var innerLine6: CAShapeLayer?
    
    private var innerLineArray: Array<CAShapeLayer> = Array()
    
    
    /// 周围顶点
    /// 点 1
    private var point1 = CGPoint(x: 0, y: 0)
    /// 点 2
    private var point2 = CGPoint(x: 0, y: 0)
    /// 点 3
    private var point3 = CGPoint(x: 0, y: 0)
    /// 点 4
    private var point4 = CGPoint(x: 0, y: 0)
    /// 点 5
    private var point5 = CGPoint(x: 0, y: 0)
    /// 点 6
    private var point6 = CGPoint(x: 0, y: 0)
    
    private var pointArray: Array<CGPoint> = Array()
    
    
    /// 需要动态描述的点
    /// 动态点 1
    private var dynamicPoint1 = CGPoint(x: 0, y: 0)
    /// 动态点 2
    private var dynamicPoint2 = CGPoint(x: 0, y: 0)
    /// 动态点 3
    private var dynamicPoint3 = CGPoint(x: 0, y: 0)
    /// 动态点 4
    private var dynamicPoint4 = CGPoint(x: 0, y: 0)
    /// 动态点 5
    private var dynamicPoint5 = CGPoint(x: 0, y: 0)
    /// 动态点 6
    private var dynamicPoint6 = CGPoint(x: 0, y: 0)
    /// 动态的 layer
    private var dynamicLayer = CAShapeLayer()
    /// 归零 path
    private var zeroPath = UIBezierPath()
    
    
    /// 获得最小的长度
    private var minLength: CGFloat {
        return self.frame.size.width > self.frame.size.height ? self.frame.size.height : self.frame.size.width;
    }
    
    /// 半径 R
    private var R: CGFloat {
        return (minLength / 2) * 0.9
    }
    
    /// 中心点 X
    private var X: CGFloat {
        return self.frame.size.width / 2
    }
    
    /// 中心点 Y
    private var Y: CGFloat {
        return self.frame.size.height / 2
    }
    
    /// 圆心角
    private var angle: CGFloat {
        return CGFloat.pi / 6
    }
    
    /// 动态颜色
    var randomColor: UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(255)) / 255.0, green: CGFloat(arc4random_uniform(255)) / 255.0, blue: CGFloat(arc4random_uniform(255)) / 255.0, alpha: 1);
    }
    
    
    /// 内部形状持续变换使用的数组
    var shapScoreArray: Array<CGFloat> = Array() {
        didSet{
            if shapScoreArray.count != 6 {return}
            //开始动画
            innerShapAnimation()
        }
    }
    
    
    /// 重复更新动画使用的数组
    var repeatScoreArray: Array<CGFloat> = Array() {
        didSet{
            
            if repeatScoreArray.count != 6 {return}
            //开始动画
            hexagonAnimation()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //在这里设置这个 View 的形状
        setUpView()

        //轮廓动画
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.outLineAnimation()
        }
    }
    

    /// 六边形轮廓使用的动画
    private func outLineAnimation() {
        
        let delay = DispatchTime.now()
        let borderTime = 0.5
        DispatchQueue.main.asyncAfter(deadline: delay) {
            
            for line in self.lineArray {
                let animation = CABasicAnimation(keyPath: "strokeEnd")
                animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
                animation.fromValue = 0
                animation.toValue = 1
                animation.duration = borderTime
                line.strokeStart = 0
                line.strokeEnd = 1;
                line.add(animation, forKey: nil)
            }
        }
        
        let innerDelay = delay + borderTime
        
        let innerLineTime = 0.3
        
        DispatchQueue.main.asyncAfter(deadline: innerDelay) {
            
            for line in self.innerLineArray {
                let animation = CABasicAnimation(keyPath: "strokeEnd")
                animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
                animation.fromValue = 0
                animation.toValue = 1
                animation.duration = innerLineTime
                line.strokeStart = 0
                line.strokeEnd = 1;
                line.add(animation, forKey: nil)
            }
        }
    }
    

    /// 持续变化内部 shap 使用的动画
    private func innerShapAnimation() {
        
        let shapTime: CFTimeInterval = 0.25
        
        let newPath = self.needPath(R: self.R, X: self.X, Y: self.Y, angle: self.angle, persentArray: shapScoreArray)
        let basicAnimation = CABasicAnimation(keyPath: "path")
        basicAnimation.duration = shapTime;
        basicAnimation.fromValue = self.dynamicLayer.path
        basicAnimation.toValue = newPath.cgPath
        self.dynamicLayer.path = newPath.cgPath
        self.dynamicLayer.add(basicAnimation, forKey: nil)
        
        let colorAnimation = CABasicAnimation(keyPath: "fillColor")
        colorAnimation.duration = shapTime;
        colorAnimation.fromValue = self.dynamicLayer.fillColor;
        let newcolor = self.randomColor.cgColor;
        colorAnimation.toValue = newcolor
        self.dynamicLayer.fillColor = newcolor
        self.dynamicLayer.add(colorAnimation, forKey: nil)
    }
    
    
    /// 重复更新动画
    private func hexagonAnimation() {
        
        //复位线条
        for line in innerLineArray {
            line.strokeStart = 0
            line.strokeEnd = 0
        }
        
        dynamicLayer.path = zeroPath.cgPath
        
        let delay = DispatchTime.now()
        
        let borderTime = 0.5
        
        DispatchQueue.main.asyncAfter(deadline: delay) {
            
            for line in self.lineArray {
                let animation = CABasicAnimation(keyPath: "strokeEnd")
                animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
                animation.fromValue = 0
                animation.toValue = 1
                animation.duration = borderTime
                line.strokeStart = 0
                line.strokeEnd = 1;
                line.add(animation, forKey: nil)
            }
        }
        
        
        let innerDelay = delay + borderTime
        
        let innerLineTime = 0.3
        
        DispatchQueue.main.asyncAfter(deadline: innerDelay) {
            
            for line in self.innerLineArray {
                let animation = CABasicAnimation(keyPath: "strokeEnd")
                animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
                animation.fromValue = 0
                animation.toValue = 1
                animation.duration = innerLineTime
                line.strokeStart = 0
                line.strokeEnd = 1;
                line.add(animation, forKey: nil)
            }
        }
        
        let shapDelay = innerDelay + borderTime
        let shapTime = 0.25
        
        DispatchQueue.main.asyncAfter(deadline: shapDelay) {
            
            let newPath = self.needPath(R: self.R, X: self.X, Y: self.Y, angle: self.angle, persentArray: self.repeatScoreArray)
            let basicAnimation = CABasicAnimation(keyPath: "path")
            basicAnimation.duration = shapTime;
            basicAnimation.fromValue = self.dynamicLayer.path
            basicAnimation.toValue = newPath.cgPath
            self.dynamicLayer.path = newPath.cgPath
            self.dynamicLayer.add(basicAnimation, forKey: nil)
        }
    }
    
  
    
    /// 初始化动画视图
    private func setUpView() {
        
        point1 = CGPoint(x: X, y: Y - R)
        
        point2 = CGPoint(x: X + R * cos(angle), y: Y - R * sin(angle))
        point3 = CGPoint(x: X + R * cos(angle), y: Y + R * sin(angle))
        point4 = CGPoint(x: X, y: Y + R)
        point5 = CGPoint(x: X - R * cos(angle), y: Y + R * sin(angle))
        point6 = CGPoint(x: X - R * cos(angle), y: Y - R * sin(angle))
        pointArray = [point1, point2, point3, point4, point5, point6]
        
        
        //创建内部线条
        let innerCenterPoint = CGPoint(x: X, y: Y)
        
        innerLine1 = needinnerLine(startPoint: point1, endPoint: innerCenterPoint)
        innerLine2 = needinnerLine(startPoint: point2, endPoint: innerCenterPoint)
        innerLine3 = needinnerLine(startPoint: point3, endPoint: innerCenterPoint)
        innerLine4 = needinnerLine(startPoint: point4, endPoint: innerCenterPoint)
        innerLine5 = needinnerLine(startPoint: point5, endPoint: innerCenterPoint)
        innerLine6 = needinnerLine(startPoint: point6, endPoint: innerCenterPoint)
        innerLineArray = [innerLine1!, innerLine2!, innerLine3!, innerLine4!, innerLine5!, innerLine6!]
        
        
        // 创建 外边框线条
        border1 = needBorderLine(startPoint: point2, endPoint: point1)
        border2 = needBorderLine(startPoint: point3, endPoint: point2)
        border3 = needBorderLine(startPoint: point4, endPoint: point3)
        border4 = needBorderLine(startPoint: point5, endPoint: point4)
        border5 = needBorderLine(startPoint: point6, endPoint: point5)
        border6 = needBorderLine(startPoint: point1, endPoint: point6)
        
        lineArray = [border1!,border2!,border3!,border4!,border5!,border6!];
        
        
        let path = UIBezierPath()
        let centerPoint = CGPoint(x: X, y: Y)
        path.move(to: centerPoint)
        path.addLine(to: centerPoint)
        path.addLine(to: centerPoint)
        path.addLine(to: centerPoint)
        path.addLine(to: centerPoint)
        path.addLine(to: centerPoint)
        path.close()
        zeroPath = path
        dynamicLayer.path = path.cgPath;
        dynamicLayer.strokeColor = UIColor.red.cgColor
        dynamicLayer.fillColor = UIColor.cyan.cgColor
        dynamicLayer.opacity = 0.4
        dynamicLayer.lineWidth = 1;
        self.layer.addSublayer(dynamicLayer)
        
    }
    
    
    /// 计算动态变化 shap 的6个点的位置
    private func needPath(R: CGFloat, X: CGFloat, Y: CGFloat, angle: CGFloat, persentArray: Array<CGFloat>) -> UIBezierPath {
        
        let R1 = R * persentArray[0]
        dynamicPoint1 = CGPoint(x: X, y: Y - R1)
        
        let R2 = R * persentArray[1]
        dynamicPoint2 = CGPoint(x: X + R2 * cos(angle), y: Y - R2 * sin(angle))
        
        let R3 = R * persentArray[2]
        dynamicPoint3 = CGPoint(x: X + R3 * cos(angle), y: Y + R3 * sin(angle))
        
        let R4 = R * persentArray[3]
        dynamicPoint4 = CGPoint(x: X, y: Y + R4)
        
        let R5 = R * persentArray[4]
        dynamicPoint5 = CGPoint(x: X - R5 * cos(angle), y: Y + R5 * sin(angle))
        
        let R6 = R * persentArray[5]
        dynamicPoint6 = CGPoint(x: X - R6 * cos(angle), y: Y - R6 * sin(angle))
        
        
        let path = UIBezierPath()
        path.move(to: dynamicPoint1)
        path.addLine(to: dynamicPoint2)
        path.addLine(to: dynamicPoint3)
        path.addLine(to: dynamicPoint4)
        path.addLine(to: dynamicPoint5)
        path.addLine(to: dynamicPoint6)
        path.close()
        
        return path
    }
    
    
    /// 画外边框线
    private func needBorderLine(startPoint: CGPoint, endPoint: CGPoint) -> CAShapeLayer {
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let lineLayer = CAShapeLayer()
        lineLayer.path            = path.cgPath;
        lineLayer.strokeColor     = UIColor.red.cgColor
        lineLayer.lineWidth       = 2;
        lineLayer.lineCap = convertToCAShapeLayerLineCap("round") //不写这句话,在线的交界处,就会出现断层
        lineLayer.strokeStart = 0 //一开始的时候线条不出来
        lineLayer.strokeEnd = 0
        
        self.layer.addSublayer(lineLayer)
        
        return lineLayer
    }
    
    
    /// 画内部线
    private func needinnerLine(startPoint: CGPoint, endPoint: CGPoint) -> CAShapeLayer {
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let lineLayer = CAShapeLayer()
        lineLayer.path            = path.cgPath;
        lineLayer.strokeColor     = UIColor.magenta.cgColor
        lineLayer.lineWidth       = 1;
        lineLayer.strokeStart = 0 //一开始的时候线条不出来
        lineLayer.strokeEnd = 0
        
        self.layer.addSublayer(lineLayer)
        
        return lineLayer
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCAShapeLayerLineCap(_ input: String) -> CAShapeLayerLineCap {
	return CAShapeLayerLineCap(rawValue: input)
}
