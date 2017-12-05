//
//  HexagonViewController.swift
//  Animations
//
//  Created by yuency on 04/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

class HexagonViewController: UIViewController {
    
    
    
    
    /// 第一种形式的六边形
    private var hexShapView1 = LiuBianXingView()
    private var timer1: Timer?
    
    /// 第二种形式的六边形
    private var hexShapView2 = LiuBianXingView()
    private var timer2: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let heightLength = view.frame.size.height / 2
        
        
        hexShapView1.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: heightLength);
        view.addSubview(hexShapView1)
        
        hexShapView2.frame = CGRect(x: 0, y: heightLength, width: view.frame.size.width, height: heightLength);
        view.addSubview(hexShapView2)
        
        
        timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(HexagonViewController.timerEvent1), userInfo: nil, repeats: true)
        
        timer2 = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(HexagonViewController.timerEvent2), userInfo: nil, repeats: true)
        
    }
    
    
    
    
    @objc func timerEvent1() {
        
        // 更新数组,开始画图
        hexShapView1.shapScoreArray = needScoreArray()
        
    }
    
    @objc func timerEvent2() {
        
        // 更新数组,开始画图
        hexShapView2.repeatScoreArray = needScoreArray()
        
    }
    
    
    func needScoreArray() -> Array<CGFloat> {
        var persentArray: Array<CGFloat>  = Array()
        for _ in 0..<6 {
            let p: CGFloat = CGFloat(arc4random_uniform(100)) * 0.01
            persentArray.append(p)
        }
        return persentArray
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// 导航栏变透明
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer1?.invalidate()
        timer2?.invalidate()
    }
}
