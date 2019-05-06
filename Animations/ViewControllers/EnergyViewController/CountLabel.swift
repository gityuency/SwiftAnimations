//
//  CountLabel.swift
//  水球动画
//
//  Created by yuency on 22/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//


/*
 https://github.com/dataxpress/UICountingLabel  计数文字 Label 作者
 
 */


import UIKit


class CountLabel: UILabel {
    
    /// 刷新用的定时器
    private var displaylink: CADisplayLink?
    
    /// 计数数组
    private var stringArray: Array<String> = Array()
    
    /// 文字动画时间
    var duration: Int = 0
    
    /// 计数
    private var arrayCount: Int = 0
    
    /// 进度 0 ~ 1
    var progress: CGFloat = 0 {
        
        didSet{
            
            let array = calculateFrameFromValue(fromValue: oldValue, toValue: progress, function: QuadraticEaseOut, frameCount: duration * 30)
            
            stringArray = array.map({ (value) -> String in
                return "\(Int(value * 100))%"
            })
    
            displaylink?.isPaused = false
        }
    }
    
    
    deinit {
        printLog("计数器消失")
    }
    
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        displaylink?.invalidate()
        displaylink = nil
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        displaylink = CADisplayLink(target: self, selector: #selector(CountLabel.updateWaterRipple))
        displaylink?.isPaused = true
        displaylink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 定时器方法 更新动画
    @objc private func updateWaterRipple() {
        
        if arrayCount == stringArray.count {
            displaylink?.isPaused = true
            arrayCount = 0
            return
        }
        
        text = stringArray[arrayCount]
        arrayCount += 1
    }
    
}
