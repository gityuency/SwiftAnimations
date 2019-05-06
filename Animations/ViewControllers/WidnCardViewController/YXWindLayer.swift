//
//  YXWindLayer.swift
//  被风吹过的夏天
//
//  Created by yuency on 2018/11/15.
//  Copyright © 2018年 yuency. All rights reserved.
//

import UIKit

class YXWindLayer: CALayer {
    
    override init() {
        super.init()
        
        pageUnCurlAnimation.yxDelegate = self
        pageCurlAnimation.yxDelegate = self
        pageEndAnimation.yxDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        printLog("卡片吹走了")
    }
    
    /// 翻页开始值
    private var FanStartProgress: Int = 0
    /// 翻页结束值
    private var FanEndProgress: Int = 1;
    /// 正翻页 还是 倒翻页
    private var nextPageDirection = true
    
    /// 属性 倒翻页动画
    private let pageUnCurlAnimation: YXTransition = {
        let c = YXTransition()
        c.setValue("e", forKey: "e")
        c.duration = 0.3
        c.isRemovedOnCompletion = false
        c.fillMode = CAMediaTimingFillMode.forwards
        c.type = convertToCATransitionType("pageUnCurl") //CATransitionType(rawValue: "pageUnCurl")
        return c
    }()
    /// 开始 倒翻页 动画
    private func startUnPageCurlAnimation() {
        pageUnCurlAnimation.startProgress = Float(FanStartProgress) * 0.1
        pageUnCurlAnimation.endProgress = Float(FanEndProgress) * 0.1
        add(pageUnCurlAnimation, forKey: nil)
    }
    
    
    /// 属性 正翻页动画
    private let pageCurlAnimation: YXTransition = {
        let c = YXTransition()
        c.setValue("s", forKey: "s")
        c.duration = 0.2
        c.isRemovedOnCompletion = false
        c.fillMode = CAMediaTimingFillMode.forwards
        c.type = convertToCATransitionType("pageCurl") //CATransitionType(rawValue: "pageCurl")
        return c
    }()
    /// 开始 正翻页 动画 (单页)
    func startPageCurlAnimation() {
        pageCurlAnimation.startProgress = Float(FanStartProgress) * 0.1
        pageCurlAnimation.endProgress = Float(FanEndProgress) * 0.1
        add(pageCurlAnimation, forKey: nil)
    }
    
    
    /// 属性 页面翻开动画
    private let pageEndAnimation: YXTransition = {
        let c = YXTransition()
        c.setValue("o", forKey: "o")
        c.duration = 0.4
        c.isRemovedOnCompletion = false
        c.fillMode = CAMediaTimingFillMode.forwards
        c.type = convertToCATransitionType("pageCurl") //CATransitionType(rawValue: "pageCurl")
        return c
    }()
    /// 开始 当前页 被翻开 动画
    private func startEndPageCurlAnimation() {
        pageEndAnimation.startProgress = Float(FanStartProgress) * 0.1
        pageEndAnimation.endProgress = Float(FanEndProgress) * 0.1
        add(pageEndAnimation, forKey: nil)
    }
    
}

/// 实现动画结束的代理
extension YXWindLayer: YXTransitionDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        //print("上次动画结束")
        
        //在每次动画结束的时候, 随机 决定下一次是 正反页 还是 到翻页
        nextPageDirection = Int(arc4random_uniform(6) % 2) == 0 ? true : false
        
        if let c = anim.value(forKey: "s") as? String, c == "s" {
            
            // 动画结束之后有两个选择, 可以继续 正翻页, 也可以选择 倒翻页
            if nextPageDirection {  //继续正翻页
                
                FanStartProgress = FanEndProgress
                FanEndProgress += 1
                
                if FanStartProgress >= 7 {  //页面翻到了 一半  在 这种情况下有两个选择, 就是, 要么倒翻, 要么翻掉这一页
                    
                    let over = Int(arc4random_uniform(6) % 2)
                    if over == 0 {  //翻掉这一页
                        FanStartProgress = 7
                        FanEndProgress = 10
                        //print("0 正 翻开这一页  \(FanStartProgress)  \(FanEndProgress)  去向: \(nextPageDirection)")
                        startEndPageCurlAnimation()
                    } else {
                        FanStartProgress = 3
                        FanEndProgress = 4
                        //print("1 倒 翻页条件  \(FanStartProgress)  \(FanEndProgress)  去向: \(nextPageDirection)")
                        startUnPageCurlAnimation() //开始到翻页
                    }
                    
                } else {
                    
                    //print("2 正 翻页条件  \(FanStartProgress)  \(FanEndProgress)  去向: \(nextPageDirection)")
                    startPageCurlAnimation() //正翻页
                }
                
            } else {  //倒翻页
                
                swap(&FanStartProgress, &FanEndProgress)  //交换起始值
                FanStartProgress = (10 - FanStartProgress)   //倒翻页的起点是 上一个正翻页动画的终点
                FanEndProgress = (10 - FanEndProgress)       //倒翻页的终点是 上一个正翻页动画的起点
                //print("3 倒 翻页条件  \(FanStartProgress)  \(FanEndProgress)  去向: \(nextPageDirection)")
                startUnPageCurlAnimation()
                
            }
            
        } else if let c = anim.value(forKey: "e") as? String, c == "e" { // 倒翻页动画结束到了这里
            
            if nextPageDirection {  //正反页
                
                swap(&FanStartProgress, &FanEndProgress)
                FanStartProgress = (10 - FanStartProgress)
                FanEndProgress = (10 - FanEndProgress)
                //print("4 正 翻页条件  \(FanStartProgress)  \(FanEndProgress)  去向: \(nextPageDirection)")
                startPageCurlAnimation()
                
            } else {  //到翻页
                FanStartProgress = FanEndProgress
                FanEndProgress += 1
                if FanStartProgress >= 10 {  //到翻页 翻到底了 ,就正翻页
                    FanStartProgress = 0
                    FanEndProgress = 1
                    //print("5 正 翻页条件  \(FanStartProgress)  \(FanEndProgress)  去向: \(nextPageDirection)")
                    startPageCurlAnimation()
                } else {
                    //print("6 倒 翻页条件  \(FanStartProgress)  \(FanEndProgress)  去向: \(nextPageDirection)")
                    startUnPageCurlAnimation()
                }
            }
            
        } else if let c = anim.value(forKey: "o") as? String, c == "o" { // 这个页面被翻掉了
            
            FanStartProgress = 0
            FanEndProgress = 1
            startPageCurlAnimation()
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCATransitionType(_ input: String) -> CATransitionType {
	return CATransitionType(rawValue: input)
}
