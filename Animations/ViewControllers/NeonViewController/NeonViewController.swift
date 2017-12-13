//
//  NeonViewController.swift
//  Animations
//
//  Created by yuency on 13/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

class NeonViewController: YXViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        
        /// 粒子
        let emitterCell = CAEmitterCell()
        emitterCell.name = "nenolight"
        emitterCell.emissionLongitude  = CGFloat(Double.pi * 2)// emissionLongitude:x-y 平面的 发 射方向
        emitterCell.velocity = 50// 粒子速度
        emitterCell.velocityRange = 50// 粒子速度范围
        emitterCell.scaleSpeed = -0.2// 缩放比例 超大火苗
        emitterCell.scale = 0.1
        emitterCell.greenSpeed = -0.1
        emitterCell.redSpeed = -0.2
        emitterCell.blueSpeed = 0.1
        emitterCell.alphaSpeed = -0.2
        emitterCell.birthRate = 100
        emitterCell.lifetime = 4
        emitterCell.color = UIColor.white.cgColor
        emitterCell.contents = UIImage(named: "nenolight")?.cgImage
        
        //发射源
        let emitterLayer = CAEmitterLayer()
        emitterLayer.position = self.view.center// 粒子发射位置
        emitterLayer.emitterSize = CGSize(width: 2, height: 2)// 控制粒子大小
        emitterLayer.renderMode = kCAEmitterLayerBackToFront
        emitterLayer.emitterMode = kCAEmitterLayerOutline// 控制发射源模式 即形状
        emitterLayer.emitterShape = kCAEmitterLayerCircle
        emitterLayer.emitterCells = [emitterCell]
        
        
        self.view.layer.addSublayer(emitterLayer)
        
    }
}
