//
//  ClockDialView.swift
//  clock
//
//  Created by yuency on 2018/11/9.
//  Copyright © 2018年 yuency. All rights reserved.
//

import UIKit

class ClockDialView: UIView {
    
    /// 装所有刻度的层
    let layerAllScales = CALayer()
    /// 装所有刻度的数组
    var arrayAllScales: Array<CALayer> = Array()
    /// 刻度的长度
    let lengthScale: CGFloat = 50
    
    /// 时针
    var hourView : RotateAnimationView!
    /// 分针
    var minuteView : RotateAnimationView!
    /// 秒针
    var secondView : RotateAnimationView!
    
    /// 小时计数
    private var hourCount: CGFloat = 0
    /// 分钟计数
    private var minuteCount: CGFloat = 0
    /// 秒数计数
    private var secondCount: CGFloat = 0
    
    /// 一秒钟的角度
    private var oneSecondAngle: CGFloat = (CGFloat.pi * 2 / 60.0)
    /// 一分钟的角度
    private var oneMinuteAngle: CGFloat = (CGFloat.pi * 2 / 3600.0)
    /// 一小时的角度
    private var oneHourAngle: CGFloat = (CGFloat.pi * 2 / 3600.0 / 12.0)
    
    /// 秒针 圆环
    private let pointerSecCirlceLayer = CAShapeLayer()
    
    /// 装所有指针的的数组
    var arrayAllPointers: Array<RotateAnimationView> = Array()
    
    /**
     * 定时器
     * 又发生了一件神奇的事情, 你把定时器在下面的这行代码里直接初始化 写成这样: private var gcdTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
     * 不管你的 queue 使用的是 main 还是 global, 然后直接使用, 都会造成循环引用, 当前表盘对象和表里面的指针对象都不能得到释放.
     * 在这种情况下, 把定时器写成可选型,然后在用的时候判断一下,没有就创建出来,可以避免循环引用
     */
    private var gcdTimer: DispatchSourceTimer?

    /// 时间格式化
    private let dateFormatter: DateFormatter = {
        let d = DateFormatter()
        d.dateFormat = "HH:mm:ss"
        return d
    }()
    
    /// 取得当前时间的数组
    var curremtTimeArray: [CGFloat]  {
        get{
            let s = dateFormatter.string(from: Date())
            let stringArray = s.components(separatedBy: ":")
            var t = stringArray.map({ time -> CGFloat in
                return CGFloat(Double(time) ?? 0)
            })
            t[2] = t[2] + 1 //指针动画占据了1.2秒时间,这里补上1秒
            return t
        }
    }
    
    deinit {
        printLog("时钟销毁")
    }
    
 
    /// 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareSecPointerCircle()
        
        prepareScales()
        
        preparePointer()
        
        prepareRoundCircle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 画秒针圆环
    private func prepareSecPointerCircle() {
        
        pointerSecCirlceLayer.frame = bounds
        layer.addSublayer(pointerSecCirlceLayer)
        
        let lightCirlcePath = UIBezierPath(arcCenter: center, radius: (bounds.width) / 2 - 12, startAngle: -CGFloat.pi * (1 / 2), endAngle: CGFloat.pi + CGFloat.pi * (1 / 2), clockwise: true)
        pointerSecCirlceLayer.path = lightCirlcePath.cgPath
        pointerSecCirlceLayer.strokeColor = UIColor.red.cgColor
        pointerSecCirlceLayer.fillColor = UIColor.clear.cgColor
        pointerSecCirlceLayer.lineWidth = 4
        pointerSecCirlceLayer.strokeStart = 0
        pointerSecCirlceLayer.strokeEnd = 0
    }
    
    /// 画刻度 12 个
    private func prepareScales() {
        
        layerAllScales.frame = bounds;
        layer.addSublayer(layerAllScales) //装所有刻度的 layer
        
        //画刻度,并把刻度存到数组做动画
        for i in 0..<12 {
            let layerScale = CALayer()
            layerScale.frame = CGRect(x: 0, y: 0, width: 4, height: lengthScale)
            layerScale.anchorPoint = CGPoint(x: 0.5, y: 1)
            layerScale.position = layerAllScales.position
            layerScale.backgroundColor = UIColor.black.cgColor
            layerScale.transform = CATransform3DMakeRotation(CGFloat.pi * 2 / 12 * CGFloat(i), 0, 0, 1)
            layerAllScales.addSublayer(layerScale)
            arrayAllScales.append(layerScale)
        }
    }
    
    /// 画指针 3 个
    private func preparePointer() {
        
        let length = bounds.width / 2 - lengthScale - 10  //秒针长度 (与刻度距离10)
        
        hourView = RotateAnimationView(pointType: RotateAnimationView.RotatePointerType.hourPointer, pointerLength: length * 0.65)
        minuteView = RotateAnimationView(pointType: RotateAnimationView.RotatePointerType.minPointer, pointerLength: length * 0.85)
        secondView = RotateAnimationView(pointType: RotateAnimationView.RotatePointerType.secPointer, pointerLength: length)
        
        arrayAllPointers.append(hourView)
        arrayAllPointers.append(minuteView)
        arrayAllPointers.append(secondView)
        
        //计算中心点,添加指针
        let p = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        for view in arrayAllPointers {
            view.center = p
            view.alpha = 0
            addSubview(view)
        }
    }
    
    /// 画圆形表盘 外圈
    private func prepareRoundCircle()  {
        let lineWidth: CGFloat = 10
        let circleLayer = CAShapeLayer()
        circleLayer.frame = bounds;
        //用画圆弧的方式画圆 圆环半径是 layer 的宽度的一半 减掉 圆环宽度的一半
        let circlePath = UIBezierPath(arcCenter: center, radius: (circleLayer.frame.width - lineWidth) / 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor = UIColor.black.cgColor;
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = lineWidth
        layer.addSublayer(circleLayer)
    }
    
    /// 刻度动画
    @objc private func showAnimationScale() {
        
        //延时
        var delayTime: CFTimeInterval = CACurrentMediaTime();
        
        //找出表盘半径
        let radius = layerAllScales.bounds.width / 2 - lengthScale
        
        //创建动画
        let scaleShotAnimation = CABasicAnimation(keyPath: "position")
        scaleShotAnimation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut) //动画效果
        scaleShotAnimation.isRemovedOnCompletion = false   //防止动画结束回复状态  在动画结束的时候,是否移除动画
        scaleShotAnimation.fillMode = CAMediaTimingFillMode.forwards; //防止动画结束回复状态  在动画结束的时候,保持动画的哪一个状态
        scaleShotAnimation.duration = 0.25  //动画时长
        
        for (i, layerScale) in arrayAllScales.enumerated() {
            
            let index = CGFloat(i)
            
            /*
             在创建指针的时候, 设置指针 layer 的 anchorPoint = CGPoint(x: 0.5, y: 1) 所以添加的第一个指针是指向 12点 方向的, 然后顺时针添加了其他的指针
             需要计算指针终点位置 距离圆心的值, 需要分别计算 x 和 y 值 首先需要知道每个指针的角度
             x y 偏移量计算:
             1.从 12 点方向开始(第一个指针的位置), 这个位置的初始 角度是 (-CGFloat.pi / 2) , 相邻指针的角度是 (360° / 12 = 30°) 也就是 (CGFloat.pi * 2 / 12)
             2.然后是第几个指针,就把这个指针的 索引值 index * 相邻指针角度(30°), 加上第一个指针的初始角度 就得到接下来每个指针的角度.
             3.使用 (半径 * 三角函数 cos) 就可以计算 在 x 方向上的距离, 这个距离有正有负
             4.使用 (半径 * 三角函数 sin) 就可以计算 在 y 方向上的距离, 这个距离有正有负
             */
            let xOff = radius * cos(-CGFloat.pi / 2 + (CGFloat.pi * 2 / 12) * index)
            let yOff = radius * sin(-CGFloat.pi / 2 + (CGFloat.pi * 2 / 12) * index)
            
            //移动的终点位置
            let newPosition = CGPoint(x: layerAllScales.bounds.width / 2 + xOff, y: layerAllScales.bounds.width / 2 + yOff)
            
            //改变动画参数
            scaleShotAnimation.fromValue = layerScale.position  //动画起始值
            scaleShotAnimation.toValue = newPosition            //动画结束值
            scaleShotAnimation.beginTime = delayTime;           //动画延时
            layerScale.add(scaleShotAnimation, forKey: nil)     //添加动画
            
            delayTime += 0.1
        }
    }
    
    /// 指针动画
    @objc private func showAnimationPointer() {
        
        hourCount = oneHourAngle * (60 * 60 * (curremtTimeArray[0]) + curremtTimeArray[1] * 60 + curremtTimeArray[2]);
        hourView.fromCircleRadian = 0
        hourView.toCircleRadian = hourView.fromCircleRadian + hourCount;
        
        minuteCount = oneMinuteAngle * (curremtTimeArray[1] * 60 + curremtTimeArray[2]);
        minuteView.fromCircleRadian = 0
        minuteView.toCircleRadian = minuteView.fromCircleRadian + minuteCount;
        
        secondCount = oneSecondAngle * (curremtTimeArray[2])
        secondView.fromCircleRadian = 0
        secondView.toCircleRadian = secondView.fromCircleRadian + secondCount;
        
        let pointerAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        pointerAnimation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeIn) //动画效果
        pointerAnimation.fromValue = 0  //动画起始值
        pointerAnimation.duration = 1  //动画时长
        
        for view in arrayAllPointers {
            view.alpha = 1
            pointerAnimation.toValue = view.toCircleRadian //动画结束值
            view.layer.transform = CATransform3DMakeRotation(view.toCircleRadian, 0, 0, 1) //为了不让视图旋转完之后跑回去 这句话也可以
            view.layer.add(pointerAnimation, forKey: nil)//添加动画
        }
    }
    
    
    /// 在视图显示到窗口的时候开始动画
    override func didMoveToWindow() {
        
        self.perform(#selector(showAnimationScale), with: nil, afterDelay: 1)
        
        self.perform(#selector(showAnimationPointer), with: nil, afterDelay: 1 + 1.2)
        
        self.perform(#selector(showScaleShineStart), with: nil, afterDelay: 1 + 1.2)
        
        self.perform(#selector(startClock), with: nil, afterDelay: 1 + 1.2 + 1)
    }
    
    /// 定时器计时 秒针转动
    @objc private func startClock() {
        if gcdTimer == nil {
            gcdTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
            gcdTimer?.schedule(deadline: .now(), repeating: .seconds(1))
            gcdTimer?.setEventHandler(handler: { [weak self] in
                DispatchQueue.main.async {
                    guard let weakSelf = self else { return }
                    weakSelf.runClock()
                }
            })
            gcdTimer?.resume()
        }
    }
    
    /*为了不频繁创建对象,把动画的创建放到外面*/
    /// 秒针圆环动画 60秒结束复位动画
    private let pointerSecAnimationS = CAKeyframeAnimation(keyPath: "strokeStart")
    /// 秒针圆环动画 每一秒动画
    private let pointerSecAnimationE = CAKeyframeAnimation(keyPath: "strokeEnd")
    /// 标记秒针圆环一圈结束
    private var pointerSecAnimationFinished = false
    
    /// 秒针圆环动画
    private func pointerCircleAnimations(second: CGFloat)  {
        let secondPercent = second / 60.0
        /// 秒针环 动画
        if secondPercent == 1 {
            pointerSecAnimationS.values = calculateFrameFromValue(fromValue: 0, toValue: 1, function: ExponentialEaseOut, frameCount: 30)
            pointerSecAnimationS.duration = 1
            pointerSecCirlceLayer.strokeStart = 1
            pointerSecCirlceLayer.strokeEnd = 1
            pointerSecCirlceLayer.add(pointerSecAnimationS, forKey: nil)
            pointerSecAnimationFinished = true
        } else {
            if pointerSecAnimationFinished { //秒针圆环在转满一圈之后复位
                pointerSecCirlceLayer.strokeStart = 0
                pointerSecCirlceLayer.strokeEnd = 0
                pointerSecAnimationFinished = false;
            }
            pointerSecAnimationE.duration = 1
            pointerSecAnimationE.values = calculateFrameFromValue(fromValue: pointerSecCirlceLayer.strokeEnd, toValue: secondPercent, function: ExponentialEaseOut, frameCount: 30)
            pointerSecCirlceLayer.strokeStart = 0
            pointerSecCirlceLayer.strokeEnd = secondPercent
            pointerSecCirlceLayer.add(pointerSecAnimationE, forKey: nil)
        }
    }
    
    /// 刻度高亮动画 每秒
    private func showScaleShineEvery(second: CGFloat) {
        let sec = Int(second)
        if sec % 5 == 0 {
            if sec == 60 {
                for scaleLayer in arrayAllScales {
                    scaleLayer.backgroundColor = UIColor.black.cgColor
                }
                arrayAllScales[0].backgroundColor = UIColor.red.cgColor
            } else {
                let scaleLayer = arrayAllScales[sec / 5]
                scaleLayer.backgroundColor = UIColor.red.cgColor
            }
        }
    }
    
    /// 刻度高亮动画 初始
    @objc private func showScaleShineStart() {
        let sec = Int(curremtTimeArray[2]) / 5
        
        for (i, layerScale) in arrayAllScales.enumerated() {
            if sec >= i {
                layerScale.backgroundColor = UIColor.red.cgColor
            }
        }
    }
    
    /// 时钟运行
    private func runClock() {
        
        let currentSecond = (curremtTimeArray[2])
                
        //秒针圆环动画
        pointerCircleAnimations(second: currentSecond)
        
        //刻度动画
        showScaleShineEvery(second: currentSecond)
        
        secondCount += oneSecondAngle
        secondView.fromCircleRadian = secondView.toCircleRadian
        secondView.toCircleRadian = secondCount
        secondView.startRotateAnimated(true)
        
        minuteCount += oneMinuteAngle
        minuteView.fromCircleRadian = minuteView.toCircleRadian
        minuteView.toCircleRadian = minuteCount
        minuteView.startRotateAnimated(true)
        
        hourCount += oneHourAngle
        hourView.fromCircleRadian = hourView.toCircleRadian
        hourView.toCircleRadian = hourCount
        hourView.startRotateAnimated(true)
    }
}
