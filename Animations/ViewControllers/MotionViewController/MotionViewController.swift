//
//  MotionViewController.swift
//  啊你妹
//
//  Created by yuency on 14/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

class MotionViewController: YXViewController {

    
    deinit {
        print("MotionViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.contents = UIImage(named: "bg_1.jpg")?.cgImage
        self.title = "摇晃手机"

        let vvvvv = PhysicalView(frame: view.bounds)
        
        vvvvv.imageNameArray = ["a01.jpg","a02.jpg","a03.jpg","a04.jpg","a05.jpg","a06.jpg","a07.jpg","a08.jpg","a09.jpg","a10.jpg","a11.jpg",];
        
        view.addSubview(vvvvv)
    
    }

   
}
