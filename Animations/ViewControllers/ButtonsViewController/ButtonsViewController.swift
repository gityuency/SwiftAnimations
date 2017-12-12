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

        let loginButton:WaterRippleButton = WaterRippleButton(frame: CGRect(x: 20, y: 230, width: self.view.frame.width-20*2,height: 50))
        loginButton.setTitle("登陆", for: UIControlState())
        loginButton.backgroundColor = UIColor.blue
        loginButton.addTarget(self, action: #selector(ButtonsViewController.loginAction(_:event:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(loginButton)
        
        
        
    }
    
    
    @objc func loginAction(_ sender:UIButton,event:UIEvent) {
        let bt:WaterRippleButton = sender as! WaterRippleButton
        bt.startButtonAnimation(sender, mevent: event)
    }
    
}
