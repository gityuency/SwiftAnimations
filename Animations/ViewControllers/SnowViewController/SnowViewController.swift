//
//  SnowViewController.swift
//  Animations
//
//  Created by yuency on 05/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import UIKit

/// 雪花 图片
class SnowViewController: YXViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.contents = UIImage(named: "bg_9.jpg")?.cgImage

        
        view.backgroundColor = UIColor.black
        
        // 创建粒子Layer
        let snowEmitter = CAEmitterLayer()
        // 粒子发射位置
        snowEmitter.emitterPosition = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: 0)
        // 发射源的尺寸大小
        snowEmitter.emitterSize = view.bounds.size
        // 发射模式
        snowEmitter.emitterMode = CAEmitterLayerEmitterMode.surface
        // 发射源的形状
        snowEmitter.emitterShape = CAEmitterLayerEmitterShape.line
        
        snowEmitter.shadowOpacity = 1.0;
        snowEmitter.shadowRadius  = 0.0;
        snowEmitter.shadowOffset = CGSize(width: 0, height: 0)
        
        // 粒子边缘的颜色
        snowEmitter.shadowColor = UIColor.white.cgColor
        
        var snowArray: Array<CAEmitterCell> = Array()
        let nameArray = ["snow_1", "snow_2", "snow_3", "snow_4", "snow_5"]
        for name in nameArray {
            snowArray.append(needSnow(snowName: name))
        }
        
        // 添加粒子
        snowEmitter.emitterCells = snowArray
        
        // 将粒子Layer添加进图层中
        view.layer.addSublayer(snowEmitter)
        
    }
    
    
    /// 设置粒子的形状
    private func needSnow(snowName: String) -> CAEmitterCell {
        
        // 创建雪花类型的粒子
        let snowflake = CAEmitterCell()
        // 粒子的名字
        snowflake.name = "snow"
        // 粒子参数的速度乘数因子
        snowflake.birthRate = 5;
        snowflake.lifetime  = 120.0;
        // 粒子速度
        snowflake.velocity  = 20.0;
        // 粒子的速度范围
        snowflake.velocityRange = 10;
        // 粒子y方向的加速度分量
        snowflake.yAcceleration = 10;
        // 周围发射角度
        snowflake.emissionRange = 0.5 * CGFloat.pi
        // 子旋转角度范围
        snowflake.spinRange = 0.5 * CGFloat.pi
        snowflake.contents = UIImage(named: snowName)?.cgImage
        // 设置雪花形状的粒子的颜色
        snowflake.color = UIColor.white.cgColor
        snowflake.redRange   = 2;
        snowflake.greenRange = 2;
        snowflake.blueRange  = 2;
        // 设置雪花的缩放
        snowflake.scaleRange = 0.5;
        snowflake.scale      = 0.5;
        
        return snowflake
    }
    
    //返回按钮点击响应
    @objc func backToPrevious(){
        self.navigationController!.popViewController(animated: true)
    }
    
}


