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
        emitterCell.scaleSpeed = -0.2// 缩放比例 粒子 速度 缩放比例
        emitterCell.scale = 0.1 //粒子的缩放比例
        emitterCell.greenSpeed = -0.1 //颜色速度渐变效果
        emitterCell.redSpeed = -0.2 //颜色速度渐变效果
        emitterCell.blueSpeed = 0.1 //颜色速度渐变效果
        emitterCell.alphaSpeed = -0.2 //透明度渐变效果
        emitterCell.birthRate = 100 //粒子生成速度
        emitterCell.lifetime = 4 //粒子生命周期
        emitterCell.color = UIColor.white.cgColor //粒子的背景颜色
        emitterCell.contents = UIImage(named: "nenolight")?.cgImage
        
        //发射源
        let emitterLayer = CAEmitterLayer()
        emitterLayer.position = self.view.center// 粒子发射位置
        emitterLayer.emitterSize = CGSize(width: 2, height: 2)// 控制粒子大小
        emitterLayer.renderMode = CAEmitterLayerRenderMode.backToFront  //渲染模式
        emitterLayer.emitterMode = CAEmitterLayerEmitterMode.outline// 控制发射源模式 即形状
        emitterLayer.emitterShape = CAEmitterLayerEmitterShape.circle //发射源形状
        emitterLayer.emitterCells = [emitterCell]
        
        
        self.view.layer.addSublayer(emitterLayer)
        
    }
}
