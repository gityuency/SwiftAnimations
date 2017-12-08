//
//  QQShapViewController.swift
//  Animations
//
//  Created by yuency on 07/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

class QQShapViewController: YXViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        let qqShap = YXShapLayer()
        qqShap.frame = view.bounds
        qqShap.position = view.center
        qqShap.beginPoint = CGPoint(x: view.center.x, y: 0)
        qqShap.image = UIImage(named: "qq.png")

        view.layer.addSublayer(qqShap)

    }
    
}
