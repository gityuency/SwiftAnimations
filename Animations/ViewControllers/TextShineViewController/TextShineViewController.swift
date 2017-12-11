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
        shineLabel.textAlignment = .center
        shineLabel.text = "《金陵五题·石头城》\n\n 刘禹锡 唐 \n\n 山围故国周遭在， \n 潮打空城寂寞回。 \n 淮水东边旧时月， \n 夜深还过女墙来。\n "
        shineLabel.numberOfLines = 0
        shineLabel.font = UIFont.systemFont(ofSize: 32)
        view.addSubview(shineLabel)
        
        
        /// 开始计时
        
        let timeCount = 0
        let codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        codeTimer.schedule(deadline: .now(), repeating: .seconds(7))
        codeTimer.setEventHandler(handler: {
            
            DispatchQueue.main.async {
                
                shineLabel.shineWithCompletion {
                    
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
