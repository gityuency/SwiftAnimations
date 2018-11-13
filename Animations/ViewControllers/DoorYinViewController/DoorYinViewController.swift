//
//  DoorYinViewController.swift
//  Animations
//
//  Created by yuency on 2018/9/5.
//  Copyright © 2018年 yuency. All rights reserved.
//

import UIKit
import AVFoundation

class DoorYinViewController: UIViewController {
    
    /// 红色
    @IBOutlet weak var imageViewRed: UIImageView!
    /// 绿色
    @IBOutlet weak var imageViewGreen: UIImageView!
    /// 紫色
    @IBOutlet weak var imageViewPurple: UIImageView!
    /// 定时器
    private var timer: Timer?
    /// 音乐播放
    private lazy var audioPlayer: AVAudioPlayer = {
        let url = Bundle.main.url(forResource: "不仅仅是喜欢.mp3", withExtension: nil) ?? URL(fileURLWithPath: "")
        let p = try? AVAudioPlayer(contentsOf: url)
        p?.prepareToPlay()
        p?.isMeteringEnabled = true;
        assert(p != nil, "请放入一段 MP3 音乐")
        return p!
    }()
    /// 动画
    private lazy var animation: CABasicAnimation = {  //定时器间隔和动画持续时间能影响动画流畅性
        let a = CABasicAnimation(keyPath: "position")
        a.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        a.fromValue = CGPoint(x: 0, y: 0)
        a.toValue = CGPoint(x: 0, y: 0)
        a.autoreverses = true //自动反转
        a.duration = 0.1
        a.repeatCount = 1
        return a
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //右下角男魂符号
        let doorView: DoorView = DoorView(frame: CGRect(x: UIScreen.main.bounds.width - 50, y: UIScreen.main.bounds.height - 50, width: 40, height: 40))
        view.addSubview(doorView)
        
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(DoorYinViewController.doorYinMusic), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
    
    deinit {
        printLog("控制器销毁")
    }
    
    /// 执行动画
    @objc private func doorYinMusic() {
        
        audioPlayer.updateMeters()
        
        let peak_1 = -(audioPlayer.peakPower(forChannel: 0))
        let peak_2 = -(audioPlayer.peakPower(forChannel: 1))
        
        var aver_1 = -(audioPlayer.averagePower(forChannel: 0))
        var aver_2 = -(audioPlayer.averagePower(forChannel: 1))
        
        aver_1 = aver_1 >= 10.0 ? 1.0 : aver_1
        aver_2 = aver_2 >= 10.0 ? 1.0 : aver_2
        
        aver_1 = arc4random_uniform(2) % 2 == 1 ? -aver_1 : aver_1;
        aver_2 = arc4random_uniform(2) % 2 == 1 ? -aver_2 : aver_2;
        
        let x = CGFloat(Int(aver_1))
        let y = CGFloat(Int(aver_2))
        
        let p1 = peak_1 + peak_2
        let p2 =  p1 > 10 ? 10 : p1
        let offset = CGFloat(Int(11 - p2))
        
        print("震动范围{\(x),\(y)} 振幅:\(offset) 音乐参数:\(peak_1),\(peak_2),\(aver_1),\(aver_2)")
        
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
    
    
    /// 抖动视图
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
    
    
    @IBAction func startDoor(_ sender: UIButton) {
        audioPlayer.play()
    }
    
}
