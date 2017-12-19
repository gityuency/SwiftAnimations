//
//  LineChartViewController.swift
//  Animations
//
//  Created by yuency on 04/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

class LineChartViewController: YXViewController {

    /// 定时器
    private let gcdTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())

    
    let vv = CurveLineView()
    
    var ccccc: Int = 1
    
    deinit {
        print("控制器 LineChartViewController 已经释放...")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.view.addSubview(vv)
        
        vv.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
        
        vv.center = view.center
        
        
        gcdTimer.schedule(deadline: .now(), repeating: .seconds(4))
        gcdTimer.setEventHandler(handler: { [weak self] in
            
            guard let weakSelf = self else { return }
            
            DispatchQueue.main.async {
                
                
                var a =  arc4random_uniform(10)
                
                if a == 0 {
                    a += 1
                }
                
                var persentArray: Array<CGFloat>  = Array()
                
                for _ in 0..<a {
                    
                    let p1: CGFloat = CGFloat(arc4random_uniform(100)) * 0.01
                    
                    persentArray.append(p1)
                }
                
                // 传入数组,就重新开始画图
                weakSelf.vv.scoreArray = persentArray
                
            }
            
        })
        gcdTimer.resume()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "月考成绩"
        /// 更改导航栏文字的颜色和字体
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor:UIColor.red,
             NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20)
        ]
    }
    
}
