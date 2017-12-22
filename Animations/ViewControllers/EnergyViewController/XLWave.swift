//
//  XLWave.swift
//  水球动画
//
//  Created by yuency on 20/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

/*
 感谢你们
 http://blog.csdn.net/u013282507/article/details/53121556 //波浪作者
 https://github.com/mengxianliang/XLWaveProgress          //波浪作者 GitHub
 
 https://github.com/mengxianliang/XLTieBaLoading  //仿百度贴吧能量球作者 GitHub

 */




import UIKit


/// 波浪动画
class XLWave: UIView {
    
    /// 背景文字
    private var backTxtLabel = CountLabel()
    /// 前景文字
    private var frontTxtLabel = CountLabel()
    
    /// 进度 0 ~ 1
    var progress: CGFloat = 0 {
        
        didSet{

            //设置文字进度
            self.backTxtLabel.progress = progress
            //设置文字进度
            self.frontTxtLabel.progress = progress
        }
    }
    
    /**
     正弦曲线公式可表示为 y = A * sin(ωx + φ) + k：
     A，振幅，最高和最低的距离
     W，角速度，用于控制周期大小，单位x中的起伏个数
     K，偏距，曲线整体上下偏移量
     φ，初相，左右移动的值
     y，值
     这个效果主要的思路是添加两条曲线 一条正玄曲线、一条余弦曲线 然后在曲线下添加深浅不同的背景颜色，从而达到波浪显示的效果
     */
    
    /// 背景波浪颜色
    var backWaveColor = UIColor(red:0.17, green:0.66, blue:0.43, alpha:1.00)
    /// 前景波浪颜色
    var frontWaveColor = UIColor(red:0.24, green:0.67, blue:0.99, alpha:1.00)

    /// 前面的波浪
    private let waveLayer1 = CAShapeLayer()
    
    /// 后面的波浪
    private let waveLayer2 = CAShapeLayer()
    
    /// 定时器
    private var disPlayLink: CADisplayLink?

    /// 曲线的振幅
    private var waveAmplitude: CGFloat = 15
    
    /// 曲线角速度
    private var wavePalstance: CGFloat = 0
    
    /// 曲线初相
    private var waveX: CGFloat = 0
    
    /// 曲线偏距
    private var waveY: CGFloat = 0
    
    /// 曲线移动速度
    private var waveMoveSpeed: CGFloat = 0
    
    /// 波浪宽度 就是 当前 View 的 Bounds.width
    private var waterWaveWidth: CGFloat {
        return bounds.size.width
    }
    
    
    deinit {
        printLog("退潮")
    }
    
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        disPlayLink?.invalidate()
        disPlayLink = nil
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildUI()
        
        buildData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func buildUI() {
        
        //初始化波浪
        //底层
        waveLayer1.fillColor = backWaveColor.cgColor
        waveLayer1.strokeColor = backWaveColor.cgColor
        layer.addSublayer(waveLayer1)
        
        //上层
        waveLayer2.fillColor = frontWaveColor.cgColor
        waveLayer2.strokeColor = frontWaveColor.cgColor
        layer.addSublayer(waveLayer2)
        
        //画了个圆
        layer.cornerRadius = bounds.size.width / 2
        layer.masksToBounds = true
        
        // 背景文字
        backTxtLabel = CountLabel(frame: bounds)
        backTxtLabel.textAlignment = .center
        backTxtLabel.center = center
        backTxtLabel.font = UIFont.systemFont(ofSize: 80)
        backTxtLabel.textColor = frontWaveColor
        backTxtLabel.duration = 2
        addSubview(backTxtLabel)

        // 前景文字
        frontTxtLabel = CountLabel(frame: bounds)
        frontTxtLabel.textAlignment = .center
        frontTxtLabel.center = center
        frontTxtLabel.font = UIFont.systemFont(ofSize: 80)
        frontTxtLabel.textColor = UIColor.white
        frontTxtLabel.duration = 2
        addSubview(frontTxtLabel)
    }
    
  
    
    /// 初始化数据
    private func buildData() {
        
        //角速度
        wavePalstance = CGFloat.pi / bounds.size.width
        
        //偏距
        waveY = bounds.size.height
        
        //x轴移动速度
        waveMoveSpeed = wavePalstance * 5
        
        //以屏幕刷新速度为周期刷新曲线的位置
        disPlayLink = CADisplayLink(target: self, selector: #selector(updateWave(link:)))
        disPlayLink?.add(to: RunLoop.main, forMode: .commonModes)
    }
    
    
    /// 定时器方法
    @objc private func updateWave(link: CADisplayLink) {
        
        waveX += waveMoveSpeed
        
        updateWaveY()
        
        updateWave1()
        
        updateWave2()
        
    }
    
    
    /// 更新曲线的偏距 正弦公式的 K 曲线整体上下移动
    private func updateWaveY() {
        
        let targetY = bounds.size.height - progress * bounds.size.height
        
        if waveY < targetY { //当前高度比目标高度小 波浪上升
            waveY += 2
        }
        
        if waveY > targetY { //当前高度比目标高度大 波浪下降
            waveY -= 2
        }
    }
    
    
    
    private func updateWave1() {
        
        //初始化运动路径
        let path = CGMutablePath()
        
        //设置起始位置
        path.move(to: CGPoint(x: 0, y: waveY))  //左下角的点
        
        //初始化波浪其实Y为偏距
        var y = waveY
        
        //余弦曲线公式为： y=Acos(ωx+φ)+k;
        for x in 0..<Int(waterWaveWidth) { //这里画波浪上的每一个点
            y = waveAmplitude * cos(wavePalstance * CGFloat(x) + waveX) + waveY
            path.addLine(to: CGPoint(x: CGFloat(x), y: y))
        }
        
        //填充底部颜色
        path.addLine(to: CGPoint(x: waterWaveWidth, y: bounds.size.height))  //右下角的点
        path.addLine(to: CGPoint(x: 0, y: bounds.size.height))  //左下角的点
        path.closeSubpath()
        waveLayer1.path = path //触发隐式动画
        
    }
    
    
    private func updateWave2() {
        
        //初始化运动路径
        let path = CGMutablePath()
        
        //设置起始位置
        path.move(to: CGPoint(x: 0, y: waveY))
        
        //初始化波浪其实Y为偏距
        var y = waveY
        
        //正弦曲线公式为： y=Asin(ωx+φ)+k;
        
        for x in 0..<Int(waterWaveWidth) {
            y = waveAmplitude * sin(wavePalstance * CGFloat(x) + waveX) + waveY
            path.addLine(to: CGPoint(x: CGFloat(x), y: y))
        }
        
        //添加终点路径、填充底部颜色
        path.addLine(to: CGPoint(x: waterWaveWidth, y: bounds.size.height))
        
        path.addLine(to: CGPoint(x: 0, y: bounds.size.height))
        
        path.closeSubpath()
        
        waveLayer2.path = path
        

        /*
         设置前面的 label 的 mask, 这样波浪的颜色就会形成透明遮罩 (有颜色的地方就会变成透明 没有颜色的地方就不透明)
         所以下部分透明,看到了 backLabel 的黄色文字,
         */
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        frontTxtLabel.layer.mask = maskLayer;
    }
    
}









