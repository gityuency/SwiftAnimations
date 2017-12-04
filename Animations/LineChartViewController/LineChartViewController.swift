//
//  LineChartViewController.swift
//  Animations
//
//  Created by yuency on 04/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

class LineChartViewController: UIViewController {

    private var timer: Timer?
    
    let vv = CurveLineView()
    
    var ccccc: Int = 1
    
    
    
    
    deinit {
        print("定时器需要释放")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.view.addSubview(vv)
        
        vv.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
        
        vv.center = view.center
        
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(LineChartViewController.timerEvent), userInfo: nil, repeats: true)
    
    }

    
    
    @objc func timerEvent() {
        
        var a =  arc4random_uniform(10)
        
        if a == 0 {
            a += 1
        }
        
        var persentArray: Array<CGFloat>  = Array()
        
        for _ in 0..<a {
            
            let p1: CGFloat = CGFloat(arc4random_uniform(100)) * 0.01
            
            persentArray.append(p1)
        }
        
        vv.scoreArray = persentArray
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
}
