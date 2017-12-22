//
//  BubbleView.swift
//  阳光下的泡沫 是彩色的 就像被骗的我 是幸福的
//  日差しの下のバブルはカラーです　騙された私のように　幸せです
//  colorfull bubble in sunshine I'm cheated but happy
//
//  Created by yuency on 14/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

/// 当年的 Windows XP  蓝天白云
class BubbleView: UIView {
    
    /*
      定时器  解除循环引用方案1: 在视图消失的函数里面 取消定时器  gcdTimer.cancel()  方案2: 定时器的 block 用到了 self 的属性, 解除引用循环
     */
    private let gcdTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
    
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
        dyitem.elasticity = 0.7;
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
    
    
    deinit {
        printLog("不吹泡泡")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func creatImageViewArrayWithDataArray(dataArray: Array<String>) {
        
        for string in dataArray {
            
            let imageView: UIImageView
            
            imageView = BubbleImageView(image: UIImage(named: string))
            
            // 图片出生位置随机
            let X = CGFloat(arc4random_uniform(200)) + center.x - 100.0
            let Y = CGFloat(arc4random_uniform(200)) + center.y - 100.0
            
            imageView.frame = CGRect(x: X, y: Y, width: 60, height: 60)
            imageView.layer.cornerRadius = 30
            imageView.layer.masksToBounds = true
            
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
        
        
        gcdTimer.schedule(deadline: .now(), repeating: .seconds(1))
        gcdTimer.setEventHandler(handler: { [weak self] in
            
            guard let weakSelf = self else { return }
            
            DispatchQueue.main.async {
                
                for behavior in weakSelf.dynamicAnimator.behaviors {
                    if let gravity = behavior as? UIGravityBehavior {
                        let XY = weakSelf.needXY()
                        gravity.gravityDirection = CGVector(dx: XY.XG, dy: XY.YG)
                    }
                }
            }
        })
        gcdTimer.resume()
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        // 取消定时器  //如果在 block 中不使用 [weak self], 在这里 取消定时器也能解除循环引用
        //gcdTimer.cancel()
    }
    
    
    /// 获得随机重力加速度
    func needXY() -> (XG: CGFloat, YG: CGFloat) {
        
        var X = CGFloat(arc4random_uniform(100)) * 0.001 * 2
        var Y = CGFloat(arc4random_uniform(100)) * 0.001 * -2
        
        
        if arc4random_uniform(5) % 2 == 0 {
            X *= -1
        }
        
        if arc4random_uniform(5) % 2 == 0 {
            Y *= -1
        }
        
        print("方向值 \(X), \(Y)")
        
        return (X, Y)
    }
}


/// 气泡图片 View
fileprivate class BubbleImageView: UIImageView {
    
    /// 气泡颜色数组
    lazy private var colorArray: Array<UIColor> = {
        
        return [
            UIColor.cyan,
            UIColor.white,
            UIColor.yellow,
            UIColor.green,
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
            UIColor(red:0.61, green:0.96, blue:0.61, alpha:1.00)
        ]
    }()
    
    /// 定时器
    private var timer: Timer?
    
    
    deinit {
        printLog("泡泡破灭")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        
        /// 定时器定时改变气泡的颜色
        let randomTime = 2 + TimeInterval(arc4random_uniform(6)) * 0.5
        timer = Timer.scheduledTimer(timeInterval: randomTime, target: self, selector: #selector(BubbleImageView.timerEvent), userInfo: nil, repeats: true)
        
    }
    
    
    // 重写这个方法, 把 Timer 弄死 否则会有循环引用!
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func timerEvent() {
        
        // 每次定时器方法调用的时候, 都渲染出一张新的颜色的图片
        let random = Int(arc4random_uniform(UInt32(colorArray.count)))
        let colorFullImage = image?.imageWithTintColor(color: colorArray[random])
        
        // 图片颜色改变的时间也是变化的
        let duration = 1 + TimeInterval(arc4random_uniform(6)) * 0.2
        
        // 改变图片, 让图片在切换的时候自然
        let contentsAnimation = CABasicAnimation(keyPath: "contents");
        contentsAnimation.fromValue = layer.contents;       //原始图片
        contentsAnimation.toValue = colorFullImage?.cgImage //切换后图片
        contentsAnimation.duration = duration;
        contentsAnimation.fillMode = kCAFillModeForwards
        contentsAnimation.isRemovedOnCompletion = false
        layer.contents = colorFullImage?.cgImage  //动画结束后设置新的图片, 要不然会有突变的生硬的感觉
        layer.add(contentsAnimation, forKey: nil)
        
    }
    
    // 重写碰撞的....
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
}



