//
//  ButtonsViewController.swift
//  Animations
//
//  Created by yuency on 12/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

class ButtonsViewController: YXViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let loginButton:WaterRippleButton = WaterRippleButton(frame: CGRect(x: 20, y: 80, width: view.bounds.size.width - 40, height: 60))
        loginButton.setTitle("不经意的思念是那么痛", for: UIControl.State())
        loginButton.setTitleColor(UIColor.white, for: .normal)
        
        //        loginButton.backgroundColor = UIColor.red  //设置背景色
                loginButton.rippleColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)    //设置波纹色
        
        loginButton.addTarget(self, action: #selector(ButtonsViewController.loginAction(_:event:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(loginButton)
        
    }
    
    
    @objc func loginAction(_ sender:UIButton,event:UIEvent) {
        let bt:WaterRippleButton = sender as! WaterRippleButton
        bt.startButtonAnimation(sender, mevent: event)
    }
    
}
