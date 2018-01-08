//
//  UIBarButtonItem+Extension.swift
//  练手微博
//
//  Created by yuency yang on 03/07/2017.
//  Copyright © 2017 ChickenMaster. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {

    
    /// 创建 UIBarButtonItem
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - fontSize: 文字大小 默认16
    ///   - target: target
    ///   - action: action
    ///   - isBackButton: 是否是返回按钮,如果是,加上箭头
    convenience init(title: String, fontSize: CGFloat = 16, target:Any?, action: Selector, isBackButton: Bool = false) {
        
        
        let btn: UIButton = UIButton.cz_textButton(title: title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange, backgroundImageName: nil)
        
        
        if isBackButton {
            let imageName = "navigationbar_back_withtext"
            btn.setImage(UIImage(named: imageName), for: UIControlState.normal)
            btn.setImage(UIImage(named: imageName + "_highlighted"), for: UIControlState.highlighted)
            btn.sizeToFit() //重新调整一下大小
        }
        
        
        btn.addTarget(target, action: action, for: .touchUpInside)
        //实例化这个 UIBarButtonItem 便利的构造函数要调用指定的构造函数
        self.init(customView: btn)
    }
    

}


extension UIButton {
    
    
    static func cz_textButton(title: String, fontSize: CGFloat, normalColor: UIColor, highlightedColor: UIColor, backgroundImageName: String?) -> UIButton {
        
        let button = UIButton()
        
        
        button.setTitle(title, for: .normal)
        
        button.setTitleColor(normalColor, for: .normal)
        
        button.setTitleColor(highlightedColor, for: .highlighted)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
        if let backgroundImageName = backgroundImageName {
            
            button.setBackgroundImage(UIImage(named: backgroundImageName), for: .normal)
            
            let backgroundImageNameHL = backgroundImageName.appending("_highlighted")
            
            button.setBackgroundImage(UIImage(named: backgroundImageNameHL), for: .highlighted)
            
        }
        
     button.sizeToFit()
        
        
        return button;
        
        
    }
    
   
    
    
}

