//
//  QQShapViewController.swift
//  Animations
//
//  Created by yuency on 07/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

class QQShapViewController: YXViewController {
    
    /// 定时器
    private let gcdTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())

    deinit {
        printLog("")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let qqShap = YXShapLayer()
        qqShap.frame = view.bounds
        qqShap.position = view.center
        qqShap.beginPoint = CGPoint(x: view.center.x, y: 0)
        qqShap.image = UIImage(named: "qq.png")
        view.layer.addSublayer(qqShap)
        
        
        gcdTimer.schedule(deadline: .now(), repeating: .seconds(12))
        gcdTimer.setEventHandler(handler: {
            
            print("画沙")
            
            DispatchQueue.main.async {
                
                qqShap.showAnimation()
                
            }
        })
        gcdTimer.resume()
        
    }
}
