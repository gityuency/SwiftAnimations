//
//  WaterRippleButton.swift
//  Animations
//
//  Created by yuency on 12/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

/*
 个人觉得这个按钮的设计方案不是很好, 使用定时器调用 drawRect 方法是比较消耗 CPU 资源的, 可以用 layer 来代替 能达到同样的效果
 这次就当是练手了, 我也不想再把这份代码重构了, 好歹花了我很多时间.
 */

import UIKit

/// 水波纹按钮
class WaterRippleButton: UIButton {
    
    /// 波浪半径
    var rippleRadius:CGFloat = 0
    
    /// 点击中心 X
    var circleCenterX:CGFloat = 0
    
    /// 点击中心 Y
    var circleCenterY:CGFloat = 0
    
    /// 刷新用的定时器
    private var displaylink: CADisplayLink?
    
    /// 波纹是否正在扩散
    private var rippNow = true
    
    /// 颜色变化数组
    private var colorArray: Array<UIColor> = Array()
    
    /// 波浪的颜色
    var rippleColor: UIColor? {
        didSet{
            
            guard let bgColorArray = self.backgroundColor?.cgColor.components,
                let ripColorArray = rippleColor?.cgColor.components else {
                    return
            }
            
            colorArray.removeAll()
            
            for i in 1..<20 {
                
                let step = (CGFloat(i) / 21.0)
                
                let stepR = colorToColor(fromColor: ripColorArray[0], toColor: bgColorArray[0], colorStep: step)
                let stepG = colorToColor(fromColor: ripColorArray[1], toColor: bgColorArray[1], colorStep: step)
                let stepB = colorToColor(fromColor: ripColorArray[2], toColor: bgColorArray[2], colorStep: step)
                
                colorArray.append(UIColor(red: stepR, green: stepG, blue: stepB, alpha: 1))
            }
        }
    }
    
    /// 获取进阶颜色值
    func colorToColor(fromColor: CGFloat, toColor: CGFloat, colorStep: CGFloat) -> CGFloat {
        let colorRange = fromColor - toColor
        if colorRange >= 0 { //新色值大于旧色值
            return fromColor - (colorRange * colorStep)
        } else {
            return fromColor + (-colorRange * colorStep)
        }
    }
    
    /// 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    /// 初始化
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    /// 初始化设置
    private func commonInit() {
        
        backgroundColor = UIColor.orange
        rippleColor = UIColor.yellow
        
        displaylink = CADisplayLink(target: self, selector: #selector(WaterRippleButton.updateWaterRipple))
        displaylink?.isPaused = true
        displaylink?.add(to: RunLoop.current, forMode: .commonModes)
    }
    
    
    /// 定时器方法 更新动画
    @objc private func updateWaterRipple() {
        
        /// 如果圆形覆盖了整个按钮, 我们就停止定时器
        let x1 = frame.size.width - circleCenterX
        let x2 = frame.size.width - x1
        let maxXLength = x1 > x2 ? x1 : x2
        
        let y1 = frame.size.height - circleCenterY
        let y2 = frame.size.height - y1
        let maxYLength = y1 > y2 ? y1 : y2
        
        let W = pow(maxXLength, 2)
        let Y = pow(maxYLength, 2)
        let R = sqrt(W + Y)
        
        if rippleRadius > R {

            rippNow = false  //进入褪色阶段
            
        } else {
            rippleRadius += 10 //波纹阶段半径逐渐增大
        }
        setNeedsDisplay()  //不管是褪色阶段还是 波纹阶段,都需要刷新
    }
    
    
    
    /// 开始动画
    func startButtonAnimation(_ msenderBt:UIButton,mevent:UIEvent){
        
        self.isUserInteractionEnabled = false
        
        let button:UIView = msenderBt as UIView
        
        let touchSet:NSSet=mevent.touches(for: button)! as NSSet
        
        var touchArray:[AnyObject] = touchSet.allObjects as [AnyObject]
        
        let touch1:UITouch = touchArray[0] as! UITouch
        
        let point1:CGPoint = touch1.location(in: button)
        
        self.circleCenterX = point1.x
        
        self.circleCenterY = point1.y
        
        displaylink?.isPaused = false //开始刷新
    }
    
    
    /// 记录颜色数组个数
    private var colorCount: Int = 0
    
    
    override func draw(_ rect: CGRect) {
        
        
        if rippNow { // 波纹扩散
            
            let ctx:CGContext = UIGraphicsGetCurrentContext()!
            
            let endangle:CGFloat = CGFloat(Double.pi*2)
            
            ctx.addArc(center:CGPoint(x:circleCenterX,y:circleCenterY),radius:rippleRadius,startAngle:0,endAngle:endangle,clockwise:false)
            
            let stockColor:UIColor = rippleColor!  //圆形半径逐渐扩大
            
            stockColor.setStroke()
            
            stockColor.setFill()
            
            ctx.fillPath()
            
            
        } else { // 波纹消退
            
            let ctx:CGContext = UIGraphicsGetCurrentContext()!
            ctx.addRect(bounds)
            let stockColor:UIColor = colorArray[colorCount]  //颜色渐变
            stockColor.setStroke()
            stockColor.setFill()
            ctx.fillPath()
            
            colorCount += 1 //每一系消退记录下一次的颜色值
            
            if colorCount == colorArray.count {
                
                rippleRadius = 0  //在褪色完成的时候, 半径重置为0
                
                rippNow = true //下一次要开始波纹
                
                self.isUserInteractionEnabled = true //用户可以点击
                
                colorCount = 0 //重置计数
                
                displaylink?.isPaused = true //暂停定时器
                
            }
        }
    }
}
