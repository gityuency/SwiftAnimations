//
//  YXShineLabel.swift
//  Label
//
//  Created by yuency on 08/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

class YXShineLabel: UILabel {
    
    //MARK: - 外部使用的属性和方法
    
    /// 闪亮 / 褪色 (这两个时间一致) 的持续时间 默认是6秒
    var shineDuration: CFTimeInterval = 3
    
    /// 是否自动发光 默认否
    var autoStart = false
    
    /// 当前是否正在闪亮
    var shining = false
    
    /// 是否可见
    var visible = false
    
    
    //MARK: - 内部的使用的属性
    private var attributedString: NSMutableAttributedString = NSMutableAttributedString()
    
    private var characterAnimationDurations: Array<Double> = Array()
    
    private var characterAnimationDelays: Array<Double> = Array()
    
    private var displaylink: CADisplayLink?
    
    private var beginTime: CFTimeInterval = 0
    
    private var endTime: CFTimeInterval = 0
    
    private var fadedOut = true
    
    private var completion: (() -> ())?
    
    
    /// 设置普通文本
    override var text: String? {
        didSet{
            guard let text = text else {
                return
            }
            self.attributedText = NSAttributedString(string: text)
        }
    }
    
    
    /// 设置富文本
    override var attributedText: NSAttributedString? {
        didSet{
            
            guard let attributedText = attributedText else {
                print("返回")
                return
            }
            
            attributedString = initialAttributedStringFromAttributedString(attributedString: attributedText)
            
            super.attributedText = attributedString
            
            for _ in 0..<attributedText.length {
                
                /// 动画的总时间均分, 然后取随机值
                let shineTime = Double(arc4random_uniform(UInt32(shineDuration / 2 * 100))) / 100.0
                
                characterAnimationDelays.append(shineTime)
                
                let remain = shineDuration - shineTime
                
                let fadeTime = Double(arc4random_uniform(UInt32(remain) * 100) ) / 100.0
                
                characterAnimationDurations.append(fadeTime)
                
            }
        }
    }
    
    /// 整理富文本属性, 设置透明度为0
    func initialAttributedStringFromAttributedString(attributedString: NSAttributedString) -> NSMutableAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
        let color = textColor.withAlphaComponent(0)
        mutableAttributedString.addAttributes([NSAttributedStringKey.foregroundColor: color], range: NSMakeRange(0, mutableAttributedString.length))
        return mutableAttributedString;
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        commonInit()
    }
    
    /// 初始化
    func commonInit() {
        textColor = UIColor.white
        displaylink = CADisplayLink(target: self, selector: #selector(YXShineLabel.updateAttributedString))
        displaylink?.isPaused = true
        displaylink?.add(to: RunLoop.current, forMode: .commonModes)
    }
    
    /// 已经放到了窗口上
    override func didMoveToWindow() {
        if self.window != nil && autoStart {
            shine()
        }
    }
    
    /// 定时器方法
    @objc func updateAttributedString() {
        
        let now = CACurrentMediaTime()
        
        for i in 0..<attributedString.length {
            
            attributedString.enumerateAttribute(NSAttributedStringKey.foregroundColor, in: NSMakeRange(i, 1), options: .longestEffectiveRangeNotRequired) { (color, range, stop) in
                
                if let color = color as? UIColor {
                    
                    let currentAlpha = color.cgColor.alpha
                    
                    let shouldUpdateAlpha = (fadedOut && currentAlpha > 0) || (!fadedOut && currentAlpha < 1) || (now - beginTime) >= characterAnimationDelays[i]
                    
                    if !shouldUpdateAlpha { return }
                    
                    var percentage = (now - beginTime - characterAnimationDelays[i]) / characterAnimationDurations[i]
                    
                    if fadedOut { percentage = 1 - percentage }
                    
                    let shineColor = textColor.withAlphaComponent(CGFloat(percentage))
                    
                    attributedString.addAttributes([NSAttributedStringKey.foregroundColor: shineColor], range: NSMakeRange(i, 1))
                }
            }
        }
        
        super.attributedText = attributedString
        
        if now > endTime {
            displaylink?.isPaused = true
            if let completion = completion  {
                completion()
            }
        }
    }
    
    /// 开始动画
    private func startAnimation() {
        beginTime = CACurrentMediaTime();
        endTime = beginTime + shineDuration;
        displaylink?.isPaused = false
    }
    
    
    //MARK: - 外部调用函数
    // MARK: 亮起来吧!
    func shine() {
        shineWithCompletion { }
    }
    
    // MARK: 亮起来吧! 我们该干点什么?
    func shineWithCompletion(completion: @escaping () -> ()) {
        if !shining && fadedOut { //不在闪亮并且不在褪色
            self.completion = completion
            fadedOut = false
            
            startAnimation()
        }
    }
    
    // MARK: 褪色了
    func fadeOut() {
        fadeOutWithCompletion {}
    }
    
    // MARK: 褪色了 要等你吗
    func fadeOutWithCompletion(completion: @escaping () -> ()) {
        if !shining  && !fadedOut {
            self.completion = completion
            fadedOut = true
            startAnimation()
        }
    }
}


