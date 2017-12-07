//
//  YXShapLayer.swift
//  Animations
//
//  Created by yuency on 07/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit
import QuartzCore

class YXShapLayer: CALayer {
    
    /// layer 自身的宽度
    lazy var selfW: CGFloat = {
        return frame.size.width
    }()
    
    ///layer 自身的高度
    lazy var selfH: CGFloat = {
        return frame.size.height
    }()
    
    /// 装有所有像素的数组模型
    var pixArray: Array<YXPixModel> = Array() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    /// 定时器
    private var displayLink: CADisplayLink?
    /// 动画时间
    private var animTime: CGFloat = 0
    /// 动画持续时间
    private var animDuration: CGFloat = 10
    /// 粒子出生位置，默认在左边顶上
    var beginPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    //忽略黑色，白色当做透明处理，默认为NO，必须在设置image前面设置
    var ignoredBlack: Bool = false
    
    //忽略白色，白色当做透明处理，默认为NO，必须在设置image前面设置
    var ignoredWhite: Bool = false
    
    
    /// 把图片给我
    var image: UIImage? {
        
        didSet{
            guard let image = image, let W = image.cgImage?.width, let H = image.cgImage?.height else {
                assertionFailure("没有要画的图片")
                return
            }
            
            print(" 图片大小 \(W) * \(H)")
            
            var array: Array<YXPixModel> = Array()  // 二维数组, 从第一行开始到最后一行,往下打印图片
            
            let pixelData = image.cgImage?.dataProvider?.data
            
            let data:UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
            
            for gao in 0..<H {
                
                for kuan in 0..<W {
                    
                    
                    let pixelInfo: Int = (W * kuan + gao) * 4
                    
                    let R = CGFloat(data[pixelInfo]) / CGFloat(255.0)
                    let G = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
                    let B = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
                    let A = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
                    
                    
                    if A == 0 || (ignoredBlack && R + G + B == 3) || (ignoredBlack && R + G + B == 0) {
                        continue  //忽略不需要的粒子
                    }
                    
                    let P = CGPoint(x: gao, y: kuan)
                    
                    let model = YXPixModel()
                    //把图像移到 layer 中间
                    let X = (selfW - CGFloat(W)) / 2 + P.x
                    let Y = (selfH - CGFloat(H)) / 2 + P.y
                    
                    model.point = CGPoint(x: X, y: Y)
                    model.color = UIColor(red: R, green: G, blue: B, alpha: A);
                    array.append(model)
                }
            }
            
            pixArray = array
            
            array.removeAll()
        }
    }
    
    
    override init() {
        super.init()
    
        createDisplayLink()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 定时器方法
    @objc func emitterAnim(displayLink: CADisplayLink) {
        setNeedsDisplay() //激活画图
        
        animTime += 0.2
    }
    
    
    override func draw(in ctx: CGContext) {
        
        var count: Int = 0
        
        for model in pixArray {
            
            if model.delayTime > animTime { //每个像素都有它的延时时间,是随机出生的, 如果这个时间比动画到达的时间大, 就先不要让这个像素出来
                continue
            }
            
            var curTime = animTime - model.delayTime //..
            
            let easeDuration = animDuration + model.delayDuration //缓动动画持续的时间??
            
            if (curTime >= easeDuration) { //到达了目的地的粒子原地等待下没到达的粒子
                curTime =  easeDuration;
                count += 1;
            }
            
            
            let curX = easeInOutQuad(time: curTime, beginPosition: beginPoint.x, endPosition: model.point.x, duration: easeDuration)
            let curY = easeInOutQuad(time: curTime, beginPosition: beginPoint.y, endPosition: model.point.y, duration: easeDuration)
            
            ctx.addEllipse(in: CGRect(x: curX, y: curY, width: 1, height: 1))
            ctx.setFillColor(model.color.cgColor)
            ctx.fillPath()
            
        }
        
        if (count == pixArray.count) {
            reset()
        }
        
    }
    
    
    /// 缓动函数计算公式 这个我真的搞不懂
    func easeInOutQuad(time: CGFloat, beginPosition: CGFloat, endPosition: CGFloat, duration: CGFloat) -> CGFloat {
        let coverDistance = endPosition - beginPosition
        var time = time
        time /= duration / 2
        if (time < 1) {
            return coverDistance * pow(time, 2) + beginPosition;
        }
        time -= time
        return -coverDistance * (time*(time-2)-1) + beginPosition
    }
    
    
    
    private func createDisplayLink() {
        
        displayLink = CADisplayLink(target: self, selector: #selector(emitterAnim(displayLink:)))
        displayLink?.add(to: RunLoop.current, forMode: .commonModes)
    }
    
    
    private func reset() {
        if displayLink != nil {
            displayLink?.invalidate()
            displayLink = nil
            animTime = 0
        }
    }
    
    
    func showAnimation() {
        reset()  //重置
        createDisplayLink() //绘画
    }
    

    
}
