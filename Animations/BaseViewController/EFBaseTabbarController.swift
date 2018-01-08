//
//  EFBaseTabbarController.swift
//  EFParents
//
//  Created by yuency on 11/08/2017.
//  Copyright © 2017 yuency. All rights reserved.
//

import UIKit

class EFBaseTabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildControllers()
        
    }
    
    let controllersArray = [
        ["clsName" : "AAAViewController",
         "title" : "首页",
         "imageName" : "home"
        ],
        ["clsName" : "AAAViewController",
         "title" : "我的",
         "imageName" : "message_center"
        ],
        ["clsName" : "AAAViewController",
         "title" : "不行",
         "imageName" : "discover"
        ],
        ["clsName" : "AAAViewController",
         "title" : "这样",
         "imageName" : "profile"
        ],
        
        ]
    
    /// 设置所有子控制器
    func setupChildControllers() {
        
        var arrayM = [UIViewController]()
        
        for dict in controllersArray {
            
            arrayM.append(controller(dict: dict))
        }
        viewControllers = arrayM
    }
    
    
    private func controller(dict: [String:Any]) -> UIViewController {
        
        //取得字典内容
        guard
            let clsName   = dict["clsName"] as? String,
            let title     = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            //这里因为要使用自定义的控制器,所以要加上命名空间前缀
            let cls = NSClassFromString(Bundle.main.nameSpaceStirng + "." + clsName) as? EFBaseViewController.Type
            else {
                return UIViewController()
        }
        
        //创建视图控制器 字符串转类
        let vc = cls.init()
        //设置文本
        vc.title = title
        //设置图片
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        //设置标题 改颜色可以使用 tintcolor 或者 apperance
        vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.orange], for: .selected)
        //系统默认是12号字体, 修改字体大小,要设置 Normal 字体大小
        vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)], for: .normal)
        
        
        //设置随机的背景色
        vc.view.backgroundColor = UIColor.randomColor()
        
        //实例化导航控制器的时候,会调用 Push 方法将 rootVC 压入栈底
        let nav = EFBaseNavigationController(rootViewController: vc)
        return nav
    }
    
    
    
    
    
}



