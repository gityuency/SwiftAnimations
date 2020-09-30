//
//  MovingView.swift
//  Animations
//
//  Created by aidong on 2020/9/30.
//  Copyright © 2020 sunny. All rights reserved.
//

import UIKit

@objc protocol MovingViewDelegate{
    ///视图已经开始移动了,进入到了父视图
    @objc optional func viewDidStart(view: MovingView)
    ///视图已经移出父视图
    @objc optional func viewDidFullOutted(view: MovingView)
}

///移动的视图
class MovingView: UIImageView {
    
    ///代理
    weak var delegate: MovingViewDelegate?
    ///标记视图是否已经开始了
    private var flagDidStart = false
    ///移动步长
    private var moveStep: CGFloat = 1
    /// 刷新用的定时器
    private var displaylink: CADisplayLink?
    
    deinit {
        printLog("视图销毁")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        backgroundColor = UIColor.randomColor.withAlphaComponent(1);
        clipsToBounds = true
        contentMode = .scaleAspectFill
        
        displaylink = CADisplayLink(target: self, selector: #selector(startViewByEveryY))
        displaylink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    func startAnimation()  {
        flagDidStart = false
        displaylink?.isPaused = false
    }
    
    @objc private func startViewByEveryY() {
        
        //移动点的个步长
        self.frame = CGRect(x: frame.origin.x, y: frame.origin.y + moveStep, width: frame.size.width, height: frame.size.height);
        
        if (flagDidStart == false) && (-frame.origin.y < frame.size.height) {
            self.delegate?.viewDidStart?(view: self)
            flagDidStart = true;
        }
        if frame.origin.y > (superview?.frame.size.height ?? 0) { //移出父视图了, 这个时候需要
            displaylink?.isPaused = true; //移出父视图,马上停止定时器
            self.delegate?.viewDidFullOutted?(view: self)
            self.frame = CGRect.zero //反正看不见,反正重新运动的时候要重新设置大小,所以这里直接置zero
        }
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        displaylink?.invalidate()
        displaylink = nil
    }
    
}
