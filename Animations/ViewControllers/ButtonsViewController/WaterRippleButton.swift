//
//  WaterRippleButton.swift
//  Animations
//
//  Created by yuency on 12/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

class WaterRippleButton: UIButton {

    /// 按钮圆角
    var viewRadius:CGFloat = 0
    
    
    var countNum:Int = 0
    
    var timer:Timer?
    
    var circleCenterX:CGFloat = 0
    
    var circleCenterY:CGFloat = 0
    
    var targetAnimColor:UIColor = UIColor().randomColor
    
    /// 记录上一次的按钮的颜色
    var animateColor: UIColor?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func startButtonAnimation(_ msenderBt:UIButton,mevent:UIEvent){
        
        self.isUserInteractionEnabled = false
        
        let button:UIView = msenderBt as UIView
        
        let touchSet:NSSet=mevent.touches(for: button)! as NSSet
        
        var touchArray:[AnyObject] = touchSet.allObjects as [AnyObject]
        
        let touch1:UITouch = touchArray[0] as! UITouch
        
        let point1:CGPoint = touch1.location(in: button)
        
        self.circleCenterX = point1.x
        
        self.circleCenterY = point1.y
        
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self,
                                     selector: #selector(WaterRippleButton.timeaction), userInfo: nil, repeats: true);
        RunLoop.main.add(timer!, forMode:RunLoopMode.commonModes)
    }
    
    @objc func timeaction(){
        
        countNum += 1
        
        let dismissTime:DispatchTime = DispatchTime.now() + Double(Int64(0*NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dismissTime, execute: {() in
            self.viewRadius += 5
            self.setNeedsDisplay()
            
        })
        if(countNum>50){
            countNum = 0
            viewRadius = 0
            timer?.invalidate()
            DispatchQueue.main.asyncAfter(deadline: dismissTime, execute: {() in
                self.viewRadius = 0
                self.setNeedsDisplay()
                
            })
            self.isUserInteractionEnabled = true
        
        }
    }
    override func draw(_ rect: CGRect) {
        let ctx:CGContext = UIGraphicsGetCurrentContext()!
        let endangle:CGFloat = CGFloat(Double.pi*2)
        ctx.addArc(center:CGPoint(x:circleCenterX,y:circleCenterY),radius:viewRadius,startAngle:0,endAngle:endangle,clockwise:false)
        let stockColor:UIColor = targetAnimColor
        stockColor.setStroke()
        stockColor.setFill()
        ctx.fillPath()
    }

}
