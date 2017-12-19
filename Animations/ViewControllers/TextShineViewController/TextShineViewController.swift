//
//  TextShineViewController.swift
//  Animations
//
//  Created by yuency on 11/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

class TextShineViewController: YXViewController {
    
    /// 如果 GCD 定时器作为函数内部变量, 是不会触发事件的
    private let gcdTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
    
    deinit {
        printLog("")
    }
    
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
        gcdTimer.schedule(deadline: .now(), repeating: .seconds(7))
        gcdTimer.setEventHandler(handler: {
            
            DispatchQueue.main.async {
                
                shineLabel.shineWithCompletion {
                                        
                    shineLabel.fadeOutWithCompletion {
                        print("一个循环结束了")
                    }
                }
            }
        })
        gcdTimer.resume()
    }

}
