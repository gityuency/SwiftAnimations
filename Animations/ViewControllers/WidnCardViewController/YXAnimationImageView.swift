//
//  YXAnimationImageView.swift
//  被风吹过的夏天
//
//  Created by yuency on 2018/11/15.
//  Copyright © 2018年 yuency. All rights reserved.
//

import UIKit

class YXAnimationImageView: UIImageView {
    
    deinit {
        printLog("图片吹走了")
    }
    
    
    /// 开始动画 (多页)
    func startWindBlowAnimation() {
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
       // try! newImage.jpegData(compressionQuality: 1)?.write(to: URL(fileURLWithPath: "/Users/yuency/Desktop/图片文件夹/a.jpg") )  //保存图片到文件
        
        let scale = UIScreen.main.scale
        
        //这里图片拿到的大小是点的大小, 不是实际图片大小, 实际的图片大小需要乘上屏幕的缩放倍数
        let imageW = newImage.size.width / 3 * scale
        let imageH = newImage.size.height / 3 * scale
        
        let frameW = frame.width / 3
        let frameH = frame.height / 3

        for i in 0..<9 {  //裁成9块
            
            let c = CGFloat(i % 3) //x
            let r = CGFloat(i / 3) //y
            
            let rect = CGRect(x: c * imageW, y: r * imageH, width: imageW, height: imageH)
            let cropImg = newImage.cgImage?.cropping(to: rect)
            
            let windLayer = YXWindLayer()
            windLayer.frame = CGRect(x: c * frameW, y: r * frameH, width: frameW, height: frameH)
            windLayer.contents = cropImg
            layer.addSublayer(windLayer)
            windLayer.startPageCurlAnimation()
        }
    }
    
    /// 开始动画 (单页)
    func startSinglePageAnimation() {
        
        let windLayer = YXWindLayer()
        windLayer.contents = image?.cgImage
        windLayer.frame = layer.bounds
        layer.addSublayer(windLayer)

        windLayer.startPageCurlAnimation()
    }
}

