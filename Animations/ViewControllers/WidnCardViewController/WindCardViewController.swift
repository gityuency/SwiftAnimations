//
//  WindCardViewController.swift
//  Animations
//
//  Created by yuency on 2018/11/15.
//  Copyright © 2018年 sunny. All rights reserved.
//

import UIKit

class WindCardViewController: YXViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        // 创建
        let windView = YXAnimationImageView()
        windView.frame = view.bounds
        //CGRect(x: 20, y: 100, width: view.frame.width - 40, height: view.frame.height - 100 - 50)  //view.bounds
        windView.image = UIImage.init(named: "bg_11")
        view.addSubview(windView)
        
        // 动画
        windView.startWindBlowAnimation()
        //windView.startSinglePageAnimation()
        
    }

}
