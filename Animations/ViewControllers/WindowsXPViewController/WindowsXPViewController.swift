//
//  WindowsXPViewController.swift
//  Animations
//
//  Created by yuency on 14/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

class WindowsXPViewController: YXViewController {
    
    
    /// 定时器
    private let gcdTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())

    
    var count: Int = 0
    
    
    deinit {
        printLog("再见了, XP")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.layer.contents = UIImage(named: "bg_1.jpg")?.cgImage
        self.title = "Windows XP"

        
        var imageArray = [
            UIImage(named: "bg_1.jpg")?.cgImage,
            UIImage(named: "bg_2.jpg")?.cgImage,
            UIImage(named: "bg_3.jpg")?.cgImage,
            UIImage(named: "bg_4.jpg")?.cgImage,
            UIImage(named: "bg_5.jpg")?.cgImage,
            UIImage(named: "bg_6.jpg")?.cgImage,
            UIImage(named: "bg_7.jpg")?.cgImage,
        ]
        
        
        gcdTimer.schedule(deadline: .now(), repeating: .seconds(4))
        
        gcdTimer.setEventHandler(handler: { [weak self] in //gcd 定时器是当前控制器的属性, gcd 的 block 里面用到了自己的变量, 循环引用
            
            guard let weakSelf = self else { return }
            
            DispatchQueue.main.async {
                
                let contentsAnimation = CABasicAnimation(keyPath: "contents");
                contentsAnimation.fromValue = weakSelf.view.layer.contents;
                contentsAnimation.toValue = imageArray[weakSelf.count]
                contentsAnimation.duration = 2;
                contentsAnimation.fillMode = kCAFillModeForwards
                contentsAnimation.isRemovedOnCompletion = false
                weakSelf.view.layer.contents = imageArray[weakSelf.count]
                weakSelf.view.layer.add(contentsAnimation, forKey: nil)
                
                if weakSelf.count == imageArray.count - 1 {
                    weakSelf.count = 0
                } else {
                    weakSelf.count += 1
                }
            }
        })
        gcdTimer.resume()
        
        
        /// 使用气泡
        let vvvvv = BubbleView(frame: view.bounds)
        
        vvvvv.imageNameArray = ["bubble_white", "bubble_white", "bubble_white", "bubble_white", "bubble_white", "bubble_white", "bubble_white", "bubble_white", "bubble_white", "bubble_white", ];
        
        view.addSubview(vvvvv)
    }
}
