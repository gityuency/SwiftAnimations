//
//  QQShapViewController.swift
//  Animations
//
//  Created by yuency on 07/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

/// 画沙
class QQShapViewController: YXViewController {
    
    /// 定时器
    //private let gcdTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
    
    deinit {
        printLog("")
    }
    
    
    /// 懒加载 懒加载的好处是可以在代码块里使用 self
    lazy var qqShap: YXShapLayer = {
        let qqShap = YXShapLayer()
        qqShap.frame = view.bounds
        qqShap.position = view.center
        qqShap.beginPoint = CGPoint(x: view.center.x, y: 0)
        qqShap.image = UIImage(named: "qq.png")
        view.layer.addSublayer(qqShap)
        return qqShap
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "点击屏幕"
        
        //gcdTimer.schedule(deadline: .now(), repeating: .seconds(14))
        //gcdTimer.setEventHandler(handler: {
        //    print("画沙")
        //    DispatchQueue.main.async {
        //        qqShap.showAnimation()
        //    }
        //})
        //gcdTimer.resume()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.title = ""
        qqShap.showAnimation()
    }
}
