//
//  YXTransition.swift
//  Animations
//
//  Created by yuency on 2018/11/15.
//  Copyright © 2018年 sunny. All rights reserved.
//

import UIKit

// https://www.jianshu.com/p/3cf308020533  iOS 完美解决CABasicAnimationDelegate强引用不释放的坑

/// 自己的动画结束代理
protocol YXTransitionDelegate: NSObjectProtocol {

    ///写一个名字和官方一样的代理
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
}

/// 官方的代理是强引用的, 所以成为代理的对象得不到释放, 内存泄露
class YXTransition: CATransition, CAAnimationDelegate {

    deinit {
        //printLog("自定义动画对象销毁")
    }
    
    /// 在这里使用 weak 关键字修饰自己的代理, 在给自己代理附上对象的时候, 把自己设置成为
    weak var yxDelegate: YXTransitionDelegate? {
        didSet{
            delegate = self //把自己设置成为官方的代理对象
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {  // 这是官方的代理回调
        yxDelegate?.animationDidStop(anim, finished: flag)  //用自己的代理对象来调用 自己的代理方法
    }
}
