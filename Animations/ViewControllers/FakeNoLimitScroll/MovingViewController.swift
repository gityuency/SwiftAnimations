//
//  MovingViewController.swift
//  Animations
//
//  Created by aidong on 2020/9/30.
//  Copyright © 2020 sunny. All rights reserved.
//

import UIKit

///这次的代码就不做整理了,想放假.就先这样吧.
class MovingViewController: UIViewController, MovingViewDelegate {
    
    deinit {
        printLog("已经销毁")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewcenter.frame = view.bounds
        viewcenter.clipsToBounds = true
        viewcenter.backgroundColor = UIColor.randomColor
        view.addSubview(viewcenter);
    }
    
    let w = UIScreen.main.bounds.size.width / 2.0
    ///容器
    let viewcenter = UIView(frame: CGRect.zero)
    ///缓存池
    var arrayMovingViews = [MovingView]()
    ///随机高度
    var arrayViewHeight = [200, 240, 280, 300, 340, 380, 400];
    ///随机图片
    var arrayImageName = ["bg_1","bg_2","bg_3","bg_4","bg_5","bg_6","bg_7","bg_8","bg_9","bg_10","bg_11"];
    ///图片索引
    var imageIndex = 0;
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let viewZuo = MovingView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: w, height: 300)) //这种设置是直接铺满父容器开始滚动
        //let viewZuo = MovingView(frame: CGRect(x: 0, y: -300, width: w, height: 300)) //这种设置,图片将会从父容器顶部开始往下
        viewZuo.image = UIImage(named: arrayImageName[1])!;
        viewZuo.delegate = self;
        viewcenter.addSubview(viewZuo)
        viewZuo.startAnimation()
        
        let viewYou = MovingView(frame: CGRect(x: w, y: UIScreen.main.bounds.size.height - 250, width: w, height: 250))
        viewYou.image = UIImage(named: arrayImageName[2])!;
        viewYou.delegate = self;
        viewcenter.addSubview(viewYou)
        viewYou.startAnimation()
    }
    
    ///代理
    func viewDidStart(view: MovingView) {
        
        if imageIndex >= arrayImageName.count {
            imageIndex = 0
        }
        
        let image = UIImage(named: arrayImageName[imageIndex])!;
        
        let k = CGFloat(arrayViewHeight[Int(arc4random_uniform(UInt32(arrayViewHeight.count)))])
        
        //在当前视图开始进入的时候,就应该准备下一个视图了
        if arrayMovingViews.count > 0 {  //有缓存,取一个出来,然后放到当前的末尾,开始动画
            let offsetY = -view.frame.origin.y
            arrayMovingViews.first?.frame = CGRect(x: view.frame.origin.x, y: -(k + offsetY), width: w, height: k)
            arrayMovingViews.first?.image = image
            arrayMovingViews.first?.startAnimation()
            arrayMovingViews.removeFirst()
        } else { //无缓存
            let offsetY = -view.frame.origin.y
            let fuck = MovingView(frame: CGRect(x: view.frame.origin.x, y: -(k + offsetY), width: w, height: k))
            fuck.image = image
            fuck.delegate = self;
            viewcenter.addSubview(fuck);
            fuck.startAnimation();
        }
        imageIndex += 1;
    }
    
    func viewDidFullOutted(view: MovingView) {
        viewcenter.sendSubviewToBack(view)
        arrayMovingViews.append(view);
    }
}
