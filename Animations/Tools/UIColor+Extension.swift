//
//  UIColor+Extension.swift
//  Animations
//
//  Created by yuency on 12/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIColor 扩展
extension UIColor {
    
    /// 随机颜色
    static var randomColor: UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256)) / 255.0, green: CGFloat(arc4random_uniform(256)) / 255.0, blue: CGFloat(arc4random_uniform(256)) / 255.0, alpha: 1)
    }
    
    /// 使用十六进制数字创建颜色，例如 0xFF0000 创建红色
    ///
    /// - Parameter hex: 颜色
    convenience init(hex: UInt32) {
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0x00ff00) >> 8
        let b = hex & 0x0000ff
        self.init(red: r, green: g, blue: b)
    }
    
    /// 使用 RGB 数值创建颜色
    ///
    /// - Parameters:
    ///   - red:  R
    ///   - green: G
    ///   - blue: B
    convenience init(red: UInt32, green: UInt32, blue: UInt32) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1)
    }
    
    
    /// 用数值初始化颜色，便于生成设计图上标明的十六进制颜色  UIColor(valueRGB: 0x666666, alpha: 1.0)
    convenience init(valueRGB: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((valueRGB & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((valueRGB & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(valueRGB & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    ///便利构造 16 进制字符串转颜色 传入: "#223344" 或者 "998ABC"
    convenience init(hexStr: String) {
        let hexString = hexStr.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x0000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    //获取某个颜色的 RGBA 值
    func iNeedRBGA() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }
    
}

