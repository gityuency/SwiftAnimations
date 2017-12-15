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
    private let codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())

    
    var ccc: Int = 0
    
    
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
        
        
        let timeCount = 0
        codeTimer.schedule(deadline: .now(), repeating: .seconds(4))
        codeTimer.setEventHandler(handler: {
            
            DispatchQueue.main.async {

                let contentsAnimation = CABasicAnimation(keyPath: "contents");
                contentsAnimation.fromValue = self.view.layer.contents;
                contentsAnimation.toValue = imageArray[self.ccc]
                contentsAnimation.duration = 2;
                contentsAnimation.fillMode = kCAFillModeForwards
                contentsAnimation.isRemovedOnCompletion = false
                self.view.layer.contents = imageArray[self.ccc]
                self.view.layer.add(contentsAnimation, forKey: nil)
                
                if self.ccc == imageArray.count - 1 {
                    self.ccc = 0
                } else {
                    self.ccc += 1
                }
                
            }
            
            if timeCount != 0 {self.codeTimer.cancel()}
        })
        codeTimer.resume()
        
        
        /// 使用气泡
        let vvvvv = BubbleView(frame: view.bounds)
        
        vvvvv.imageNameArray = ["bubble_white", "bubble_white", "bubble_white", "bubble_white", "bubble_white", "bubble_white", "bubble_white", "bubble_white", "bubble_white", "bubble_white", ];
        
        view.addSubview(vvvvv)
    }
    
    
}
