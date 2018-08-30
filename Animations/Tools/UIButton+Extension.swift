//
//  UIButton+Extension.swift
//  Animations
//
//  Created by yuency on 08/01/2018.
//  Copyright © 2018 sunny. All rights reserved.
//

import Foundation
import UIKit

/// 按钮 扩展
extension UIButton {
    
    
    static func yxTextButton(title: String, fontSize: CGFloat, normalColor: UIColor, highlightedColor: UIColor, backgroundImageName: String?) -> UIButton {
        
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



