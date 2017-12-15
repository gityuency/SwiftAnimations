//
//  WindowsXPViewController.swift
//  Animations
//
//  Created by yuency on 14/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

class WindowsXPViewController: YXViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.contents = UIImage(named: "bg_4.jpg")?.cgImage
        self.title = "Windows XP"
        
        
        let vvvvv = BubbleView(frame: view.bounds)
        
        vvvvv.imageNameArray = ["bubble_white", "bubble_white", "bubble_white", "bubble_white", "bubble_white", "bubble_white", "bubble_white", "bubble_white", "bubble_white", "bubble_white", ];
        
        view.addSubview(vvvvv)
    }
    
    
}
