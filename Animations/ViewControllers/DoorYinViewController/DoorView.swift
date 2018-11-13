//
//  DoorView.swift
//  Animations
//
//  Created by yuency on 2018/9/5.
//  Copyright © 2018年 yuency. All rights reserved.
//

import UIKit

/// 抖音
class DoorView: UIView {
    
    /// 定时器
    private var timer: Timer?
    /// 绿色
    private let imageViewRed = UIImageView(image: UIImage(named: "door_green"))
    /// 红色
    private let imageViewGreen = UIImageView(image: UIImage(named: "door_red"))
    /// 紫色
    private let imageViewPurple = UIImageView(image: UIImage(named: "door_purple"))
    /// 动画
    private lazy var animation: CABasicAnimation = {  //定时器间隔和动画持续时间能影响动画流畅性
        let a = CABasicAnimation(keyPath: "position")
        a.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        a.fromValue = CGPoint(x: 0, y: 0)
        a.toValue = CGPoint(x: 0, y: 0)
        a.autoreverses = true //自动反转
        a.duration = 0.1
        a.repeatCount = 3
        return a
    }()
    
    deinit {
        printLog("不抖了...")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageViewRed)
        addSubview(imageViewGreen)
        addSubview(imageViewPurple)
        
        imageViewRed.frame = bounds
        imageViewGreen.frame = bounds
        imageViewPurple.frame = bounds
        
        timer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(DoorView.doorYinMusic), userInfo: nil, repeats: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func doorYinMusic() {
        
        //计算震动位置, 使用随机点
        let x = CGFloat(arc4random_uniform(11)) - 5.0
        let y = CGFloat(arc4random_uniform(11)) - 5.0
        //震动范围
        let offset = CGFloat(arc4random_uniform(4))
        
        if ((x > 0 && y <= 0)) {  //左上方
            let pG = CGPoint(x: x + offset, y: y - offset)
            shake(view: imageViewGreen, point: pG)
            let pR = CGPoint(x: x - offset, y: y + offset)
            shake(view: imageViewRed, point: pR)
        } else if ((x <= 0 && y < 0)) { //右上方
            let pG = CGPoint(x: x - offset, y: y - offset)
            shake(view: imageViewGreen, point: pG)
            let pR = CGPoint(x: x + offset, y: y + offset)
            shake(view: imageViewRed, point: pR)
        } else if ((x >= 0 && y > 0)) { // 左下方
            let pR = CGPoint(x: x + offset, y: y + offset)
            shake(view: imageViewRed, point: pR)
            let pG = CGPoint(x: x - offset, y: y - offset)
            shake(view: imageViewGreen, point: pG)
        } else if ((x < 0 && y >= 0)) { //右下方
            let pR = CGPoint (x: x - offset, y: y + offset)
            shake(view: imageViewRed, point: pR)
            let pG = CGPoint(x: x + offset, y: y - offset)
            shake(view: imageViewGreen, point: pG)
        }
        shake(view: imageViewPurple, point: CGPoint(x: x, y: y))
    }
    
    /// 抖动前景view
    private func shake(view: UIView, point: CGPoint) {
        //获取到当前View的layer
        let viewLayer = view.layer
        //获取当前View的位置
        let position = viewLayer.position
        //移动的两个终点位置
        let beginPosition = CGPoint(x: position.x, y: position.y)
        let endPosition = CGPoint(x: position.x - point.x, y: position.y + point.y)
        //更新动画参数
        animation.fromValue = beginPosition
        animation.toValue = endPosition
        viewLayer.add(animation, forKey: "shake")
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        timer?.invalidate()
        timer = nil
    }
}
