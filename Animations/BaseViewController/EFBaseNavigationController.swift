//
//  EFBaseNavigationController.swift
//  EFParents
//
//  Created by yuency on 11/08/2017.
//  Copyright © 2017 yuency. All rights reserved.
//

import UIKit

class EFBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
    ///重写 push 方法所有的 push 都会调用这个方法
    // viewController 这个传进来的参数是被 push 进来的控制器, 可以设置左侧的按钮作为返回按钮
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        //如果不是栈底控制器才需要隐藏 根控制器不需要隐藏
        if children.count > 0 {
            //隐藏底部的 TabBar
            viewController.hidesBottomBarWhenPushed = true
            
            //判断控制器的类型来设置返回按钮
            if let vc = viewController as? EFBaseViewController {
                
                var title = "返回"
                
                //判断控制器的级数,只有一个子控制器的时候,显示栈栈底控制的标题
                if children.count == 1 {
                    title = children.first?.title ?? "返回"
                }
                
                //取出自定义的 navItem
                vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: title, target:  self, action: #selector(popToParent), isBackButton: true)
                
            }
            
        }
        
        super.pushViewController(viewController, animated: true)
    }
    
    @objc private func popToParent() {
        popViewController(animated: true)
    }

    
    // MARK: - 禁止横屏
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
        set {
        }
    }
}
