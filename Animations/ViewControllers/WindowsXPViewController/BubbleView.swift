//
//  BubbleView.swift
//  核心动画练习
//
//  Created by yuency on 14/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

/// 当年的 Windows XP 操作系统 蓝天白云屏保
class BubbleView: UIView {
    
    /// 外部使用的属性
    var imageNameArray: Array<String> = Array() {
        didSet{
            creatImageViewArrayWithDataArray(dataArray: imageNameArray)
        }
    }
    
    /// 物理仿真器
    private lazy var dynamicAnimator: UIDynamicAnimator = {
        return UIDynamicAnimator(referenceView: self)
    }()
    
    /// 碰撞行为
    private lazy var collision: UICollisionBehavior = {
        
        let coll = UICollisionBehavior()
        // 以参照视图作为碰撞行为的边界
        coll.translatesReferenceBoundsIntoBoundary = true
        
        return coll
    }()
    
    
    /// 元素自身参数行为
    private lazy var dynamicItem: UIDynamicItemBehavior = {
        
        let dyitem = UIDynamicItemBehavior()
        //设置视图的辅助行为(本身参数 弹性系数 阻力等)
        // Usually between 0 (inelastic) and 1 (collide elastically)  弹性系数
        dyitem.elasticity = 0.8;
        // 0 being no friction between objects slide along each other  摩擦力
        dyitem.friction = 0;
        // 1 by default                                                密度
        dyitem.density = 0;
        // 0: no velocity damping                                      阻力
        dyitem.resistance = 0;
        // : no angular velocity damping                               速度阻尼
        dyitem.angularResistance = 0;
        // force an item to never rotate                               是否允许旋转
        dyitem.allowsRotation = true;
        
        return dyitem
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func creatImageViewArrayWithDataArray(dataArray: Array<String>) {
        
        for string in dataArray {
            
            let imageView: UIImageView
            
            imageView = RoundImageView(image: UIImage(named: string))
            
            // 图片出生位置随机
            let X = CGFloat(arc4random_uniform(200)) + center.x - 100.0
            let Y = CGFloat(arc4random_uniform(200)) + center.y - 100.0
            
            imageView.frame = CGRect(x: X, y: Y, width: 60, height: 60)
            imageView.layer.cornerRadius = 30
            imageView.layer.masksToBounds = true
            
            imageView.backgroundColor = UIColor.yellow
            addSubview(imageView)
            
            ///把图片添加到 重力行为 碰撞行为
            let gravity = UIGravityBehavior(items: [imageView])
            self.dynamicAnimator.addBehavior(gravity)
            
            
            collision.addItem(imageView)
            dynamicItem.addItem(imageView)
        }
        
        
        // 在设定完重力方向之后，需要将重力行为、碰撞行为添加到物理仿真器中
        self.dynamicAnimator.addBehavior(self.collision)
        self.dynamicAnimator.addBehavior(self.dynamicItem)
        
        
        let timeCount = 0
        let codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1))
        codeTimer.setEventHandler(handler: {
            
            DispatchQueue.main.async {
                
                for behavior in self.dynamicAnimator.behaviors {
                    if let gravity = behavior as? UIGravityBehavior {
                        let XY = self.needXY()
                        gravity.gravityDirection = CGVector(dx: XY.XG, dy: XY.YG)
                    }
                }
            }
            
            if timeCount != 0 {codeTimer.cancel()}
        })
        codeTimer.resume()
    }
    
    /// 获得随机重力加速度
    func needXY() -> (XG: CGFloat, YG: CGFloat) {
        
        var X = CGFloat(arc4random_uniform(100)) * 0.001
        var Y = CGFloat(arc4random_uniform(100)) * 0.001
        
        print("........\(X). \(Y).......")
        
        if arc4random_uniform(5) % 2 == 0 {
            X *= -1
        }
        
        if arc4random_uniform(5) % 2 == 0 {
            Y *= -1
        }
        
        return (2 * X, -2 * Y)
    }
}
