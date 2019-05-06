//
//  DropDownManager.swift
//  Animations
//
//  Created by 姬友大人 on 2019/5/6.
//  Copyright © 2019 sunny. All rights reserved.
//

import Foundation
import UIKit

class DropDownManager {
    
    static var arrayAllModel = [DropModel]()
    
    deinit {
        print("⭕️ DropManager ")
    }
    
    init(text: String, inView: UIView) {
        
        DropModel.arrayAllFrames.removeAll()
        DropModel.count = 0
        
        //分离字符串
        var array = [String]()
        for i in text {
            array.append(String(i))
        }
        
        //生成模型
        for item in array {
            let m = DropModel(text: item, inView: inView)
            DropDownManager.arrayAllModel.append(m)
        }
        
        print("文字个数 \(text.count)  本次一共计算了: \(DropModel.count)")
    }
    
    func show() {
        for label in DropDownManager.arrayAllModel {
            label.show();
        }
    }
    
}


class DropModel: NSObject,  YXKeyFrameDelegate {
    
    /// 重叠了多少次 (打印计数用)
    static var count = 0
    
    /// 最开始的位置 (处于屏幕上方)
    var dropStartFrame = CGRect.zero;
    
    /// 下坠停止的位置 (屏幕内)
    var dropEndFrame = CGRect.zero;
    
    /// 掉落到底部的的位置 (屏幕底部)
    var dropBottomFrame = CGRect.zero;
    
    /// 收集所有label的大小尺寸数组
    static var arrayAllFrames = [CGRect]()
    
    /// 记录本次动画中有多少个label已经结束了动画,当, countFinished == arrayFrames.count 的时候,就是所有label都结束了动画
    static var countFinished = 0
    
    /// 开始点 在屏幕上方
    var startPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    /// 结束点 在屏幕内
    var endPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    /// 进入屏幕的延时时间
    var delayTime: CFTimeInterval = 0
    
    /// 父控件
    var inView = UIView()
    
    /// 需要计算的Y长度
    var maxYlength: UInt32 = 0
    
    /// 如果对于当前label重新找位置的次数太多,那么认为是当前这一列上没有足够的位置,这时候就考虑更改X的位置,然后重新找Y
    var refindCount = 0
    
    /// 开始升起的时间
    var raiseStartTime: CFTimeInterval = 0
    
    /// 文本框
    var label: UILabel
    
    /// 旋转动画
    var animationRotate: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 4
        animation.duration = 2
        animation.autoreverses = false;
        animation.fillMode = kCAFillModeForwards
        animation.repeatCount = 1
        return animation
    }()
    
    /// 下坠动画
    var animationDrop: YXKeyframeAnimation = {
        let animation = YXKeyframeAnimation(keyPath: "position");
        animation.setValue("D", forKey: "D")
        animation.duration = 4;
        animation.fillMode = kCAFillModeForwards
        animation.repeatCount = 1
        animation.autoreverses = false;
        animation.isRemovedOnCompletion = false
        return animation;
    }()
    
    /// 降落到底部
    var animationDropBottom: YXKeyframeAnimation = {
        let animation = YXKeyframeAnimation(keyPath: "position");
        animation.setValue("W", forKey: "W")
        animation.duration = 2;
        animation.fillMode = kCAFillModeForwards
        animation.repeatCount = 1
        animation.autoreverses = false;
        animation.isRemovedOnCompletion = false
        return animation
    }()
    
    /// 升起来
    var animationRaise: YXKeyframeAnimation = {
        let animation = YXKeyframeAnimation(keyPath: "position");
        animation.setValue("R", forKey: "R")
        animation.duration = 0.1 * Double(arc4random_uniform(21)) + 2;
        animation.fillMode = kCAFillModeForwards
        animation.repeatCount = 1
        animation.autoreverses = false;
        animation.isRemovedOnCompletion = false
        return animation
    }()
    
    
    deinit {
        print("⭕️ DropModel ")
    }
    
    /// 初始化
    init(text: String, inView: UIView) {
        
        self.inView = inView
        
        label = UILabel()
        label.text = text;
        let fontsize = CGFloat(20 + 2 * arc4random_uniform(10))
        label.font = UIFont.systemFont(ofSize: fontsize)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.randomColor
        label.sizeToFit()
        
        //在label确定大小之后找到最大的高度
        maxYlength = UInt32(inView.frame.height - label.frame.height)
        
        super.init()
        
        // 设置动画代理
        animationDrop.yxDelegate = self
        animationDropBottom.yxDelegate = self
        animationRaise.yxDelegate = self
        
        refindHorizontalPlace()
        
        inView.addSubview(label)
        
        delayTime = 0.1 * Double(arc4random_uniform(11))
        
        refindVerticalPlace()
    }
    
    /// 给label指定 X
    func refindHorizontalPlace() {
        let startOriX: CGFloat = CGFloat(arc4random_uniform(UInt32(inView.frame.width - label.frame.width)))
        let startOriY = -label.frame.height
        startPoint = CGPoint(x: startOriX + label.frame.width / 2, y: startOriY + label.frame.height / 2)
        label.frame = CGRect(x: startOriX, y: startOriY, width: label.frame.width, height: label.frame.height)
    }
    
    /// 为了不和任何一个之前已经存在的label重叠 给label 指定 Y
    func refindVerticalPlace() {
        
        let endOriY: CGFloat = CGFloat(arc4random_uniform(maxYlength))
        
        let currentFrame = CGRect(x: label.frame.origin.x, y: endOriY, width: label.frame.width, height: label.frame.height)
        
        //重叠标记
        var conflict = false
        
        for frame in DropModel.arrayAllFrames {
            if frame.intersects(currentFrame) { //有重叠的部分
                conflict = true
                print("+ 重叠了 Y")
                DropModel.count += 1
                refindCount += 1
                break;
            }
        }
        
        if conflict {
            if refindCount > 4 {  //在一条线上的查找次数过多
                refindCount = 0
                print("- 重新取得 X")
                refindHorizontalPlace();
                refindVerticalPlace()
            } else {
                refindVerticalPlace()
            }
        } else {
            dropStartFrame = label.frame
            dropBottomFrame = CGRect(x: label.frame.origin.x, y: inView.frame.height - label.frame.height, width: label.frame.width, height: label.frame.height);
            endPoint = CGPoint(x: startPoint.x, y: endOriY + label.frame.height / 2)
            dropEndFrame = currentFrame
            DropModel.arrayAllFrames.append(currentFrame)
        }
    }
    
    // 开始动画
    func show() {
        
        //先恢复到起始位置
        label.frame = dropStartFrame
        
        //升起的时间
        raiseStartTime = CACurrentMediaTime() + 8 - delayTime
        
        let beginTime = CACurrentMediaTime() + delayTime
        
        animationRotate.beginTime = beginTime
        
        animationDrop.beginTime = beginTime
        animationDrop.values = calculateFrameFromPoint(fromPoint: startPoint, toPoint: endPoint, function: ElasticEaseOut, frameCount: 20)
        
        label.layer.add(animationRotate, forKey: "")
        label.layer.add(animationDrop, forKey: "")
    }
    
    
    /// 动画代理,动画结束
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        if let c = anim.value(forKey: "D") as? String, c == "D" {
            
            label.frame = dropEndFrame
            
            animationDropBottom.values = calculateFrameFromPoint(fromPoint: label.center, toPoint: CGPoint(x: label.center.x, y: inView.frame.height - label.frame.height / 2), function: BounceEaseOut, frameCount: 20)
            
            label.layer.add(animationDropBottom, forKey: "")
            
        } else if let c = anim.value(forKey: "W") as? String, c == "W"  {
            
            label.frame = dropBottomFrame
            
            animationRaise.beginTime = raiseStartTime
            animationRaise.values = calculateFrameFromPoint(fromPoint: label.center, toPoint: CGPoint(x: label.center.x, y: -label.frame.height), function: QuarticEaseOut, frameCount: 20)
            /*
             CubicEaseInOut
             QuarticEaseOut
             ExponentialEaseIn
             */
            label.layer.add(animationRaise, forKey: "")
            
        } else if let c = anim.value(forKey: "R") as? String, c == "R"  {
            
            DropModel.countFinished += 1
            if DropModel.countFinished == DropModel.arrayAllFrames.count {
                
                DropDownManager.arrayAllModel.removeAll()
                
                DropModel.arrayAllFrames.removeAll()
                
                DropModel.count = 0
                
                DropModel.countFinished = 0
            }
            
            label.removeFromSuperview()
        }
    }
}




// https://www.jianshu.com/p/3cf308020533  iOS 完美解决CABasicAnimationDelegate强引用不释放的坑

/// 自己的动画结束代理
fileprivate protocol YXKeyFrameDelegate: NSObjectProtocol {
    
    ///写一个名字和官方一样的代理
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
}

/// 官方的代理是强引用的, 所以成为代理的对象得不到释放, 内存泄露
class YXKeyframeAnimation: CAKeyframeAnimation, CAAnimationDelegate {
    
    deinit {
        //print("⭕️ YXKeyframeAnimation 自定义动画对象销毁")
    }
    
    /// 在这里使用 weak 关键字修饰自己的代理, 在给自己代理附上对象的时候, 把自己设置成为
   fileprivate weak var yxDelegate: YXKeyFrameDelegate? {
        didSet{
            delegate = self //把自己设置成为官方的代理对象
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {  // 这是官方的代理回调
        yxDelegate?.animationDidStop(anim, finished: flag)  //用自己的代理对象来调用 自己的代理方法
    }
}

