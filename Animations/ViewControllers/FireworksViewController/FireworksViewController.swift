//
//  FireworksViewController.swift
//  Animations
//  一起去看哈呐哔
//  Created by yuency on 05/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

class FireworksViewController: YXViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.contents = UIImage(named: "bg_10.jpg")?.cgImage

        
        /* 这个粒子参数很难调, 想要调出惊人的效果需要美学, 很遗憾, 我没有 */
        
        
        view.backgroundColor = UIColor.black
        
        // Cells spawn in the bottom, moving up
        
        //分为3种粒子，子弹粒子，爆炸粒子，散开粒子
        let fireworksEmitter = CAEmitterLayer()
        let viewBounds = view.layer.bounds
        
        // 粒子发射点, 从屏幕底端中心点发射
        fireworksEmitter.emitterPosition = CGPoint(x: viewBounds.size.width / 2, y: viewBounds.size.height)
        //发射源的大小
        fireworksEmitter.emitterSize    = CGSize(width: viewBounds.size.width / 2, height: 0)
        //发射模式
        fireworksEmitter.emitterMode    = kCAEmitterLayerOutline;
        //发射形状
        fireworksEmitter.emitterShape   = kCAEmitterLayerLine;
        fireworksEmitter.renderMode     = kCAEmitterLayerAdditive;
        fireworksEmitter.seed = UInt32(100)
        
        
        
        // Create the rocket
        let rocket = CAEmitterCell()
        
        rocket.birthRate        = 2.0;
        rocket.emissionRange    = 0.25 * CGFloat.pi;  // some variation in angle
        rocket.velocity         = 500;
        rocket.velocityRange    = 100;
        rocket.yAcceleration    = 75;
        rocket.lifetime         = 1.02; // we cannot set the birthrate < 1.0 for the burst
        rocket.contents         = UIImage(named: "rocket")?.cgImage
        rocket.scale            = 1;
        rocket.color            = UIColor.white.cgColor
        rocket.greenRange       = 1;      // different colors
        rocket.redRange         = 1;
        rocket.blueRange        = 1;
        rocket.spinRange        = CGFloat.pi;     // slow spin
        
        
        // the burst object cannot be seen, but will spawn the sparks
        // we change the color here, since the sparks inherit its value
        let burst = CAEmitterCell()
        burst.birthRate         = 1.0;      // at the end of travel
        burst.velocity          = 0;        //速度为0
        burst.scale             = 2.5;      //大小
        burst.redSpeed          = -1.5;      // shifting
        burst.blueSpeed         = +1.5;      // shifting
        burst.greenSpeed        = +1.0;      // shifting
        burst.lifetime          = 0.35;     //存在时间
        
        
        
        // and finally, the sparks
        let spark = CAEmitterCell()
        spark.birthRate         = 400;
        spark.velocity          = 125;
        spark.emissionRange     = 2 * CGFloat.pi;  // 360 度
        spark.yAcceleration     = 60;              // 烟花粒子掉落的重力
        spark.lifetime          = 3;
        spark.lifetimeRange     = 0.5
        spark.contents          = UIImage(named: "spark")?.cgImage
        
        spark.speed = 2
        
        spark.scale = 0.3
        spark.scaleRange = 0.1
        spark.scaleSpeed        = -0.2;
        spark.alphaSpeed        = -0.8;
        
        spark.color = UIColor.white.cgColor
        spark.greenRange       = 5;      // different colors
        spark.redRange         = 5;
        spark.blueRange        = 5;

        spark.greenSpeed        = -0.1;
        spark.redSpeed          = 0.4;
        spark.blueSpeed         = -0.1;
        
        spark.spin              = 2 * CGFloat.pi; //自旋转角度
        spark.spinRange         = 2 * CGFloat.pi; //自旋转角度范围
        
        // 3种粒子组合，可以根据顺序，依次烟花弹－烟花弹粒子爆炸－爆炸散开粒子
        fireworksEmitter.emitterCells   = [rocket];
        rocket.emitterCells             = [burst];
        burst.emitterCells              = [spark];
        
        
        view.layer.addSublayer(fireworksEmitter)
        
        
    }
    
}
