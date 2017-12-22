//
//  EnergyViewController.swift
//  Animations
//
//  Created by yuency on 22/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

class EnergyViewController: YXViewController {

    
    /// 定时器
    private let gcdTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())

    
    deinit {
        printLog("")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.contents = UIImage(named: "bg_5.jpg")?.cgImage
        
        
        //创建能量球
        let energySphereView = EnergySphereView(frame: view.bounds)
        view.addSubview(energySphereView)
        
        
        gcdTimer.schedule(deadline: .now(), repeating: .seconds(4))
        gcdTimer.setEventHandler(handler: {
            
            DispatchQueue.main.async {
                
                let rrr = CGFloat(arc4random_uniform(101)) * 0.01
                print("随机数结果:  \(rrr)")
                energySphereView.progress = rrr
                
            }
            
        })
        gcdTimer.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
