//
//  ClockViewController.swift
//  Animations
//
//  Created by yuency on 2018/11/12.
//  Copyright © 2018年 sunny. All rights reserved.
//

import UIKit

class ClockViewController: YXViewController {

    ///表盘
    var clolckDialView: ClockDialView!
    
    deinit {
        printLog("下一次吻别在哪座车站?")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        clolckDialView = ClockDialView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width))
        clolckDialView.center = view.center
        view.addSubview(clolckDialView)
    }
}
