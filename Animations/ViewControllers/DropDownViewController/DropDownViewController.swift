//
//  DropDownViewController.swift
//  Animations
//
//  Created by 姬友大人 on 2019/5/6.
//  Copyright © 2019 sunny. All rights reserved.
//

import UIKit

class DropDownViewController: UIViewController {

    private var gcdTimer: DispatchSourceTimer?

    deinit {
        printLog("退散")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gcdTimer == nil {
            gcdTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
            gcdTimer?.schedule(deadline: .now(), repeating: .seconds(14))
            gcdTimer?.setEventHandler(handler: { [weak self] in
                DispatchQueue.main.async {
                    
                    guard let weakSelf = self else { return }
                    let s =  "☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆"
                    
                    let k = DropDownManager(text: s, inView: weakSelf.view)
                    k.show()
                    
                }
            })
            gcdTimer?.resume()
        }
    }
}
