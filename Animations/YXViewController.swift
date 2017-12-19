//
//  YXViewController.swift
//  Animations
//
//  Created by yuency on 06/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

class YXViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// 导航栏变透明
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }
    
}
