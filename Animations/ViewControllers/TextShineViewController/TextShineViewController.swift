//
//  TextShineViewController.swift
//  Animations
//
//  Created by yuency on 11/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

class TextShineViewController: YXViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 设置背景图片
        view.layer.contents = UIImage(named: "bg_2.jpg")?.cgImage
        
        
        let shineLabel = YXShineLabel()
        shineLabel.frame = view.bounds
        shineLabel.textAlignment = .left
        shineLabel.text = "My name is Van, \nI'm an artist. \nI'm a performance artist. \nI'm hired for people to profile fantasies, \nThe Deep Dark Fantasies."
        shineLabel.numberOfLines = 0
        shineLabel.font = UIFont.systemFont(ofSize: 32)
        view.addSubview(shineLabel)
        
        
        /// 开始计时
        
        let timeCount = 0
        let codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        codeTimer.schedule(deadline: .now(), repeating: .seconds(9))
        codeTimer.setEventHandler(handler: {
            
            DispatchQueue.main.async {
                
                shineLabel.shineWithCompletion {
                    
                    sleep(2)
                    
                    shineLabel.fadeOutWithCompletion {
                        print("潮起潮落结束了")
                    }
                }
            }
            
            if timeCount != 0 {codeTimer.cancel()}
        })
        codeTimer.resume()
        
    }
    
    
    
}
