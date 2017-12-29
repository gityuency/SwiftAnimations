//
//  Array+Extension.swift
//  Animations
//
//  Created by yuency on 29/12/2017.
//  Copyright © 2017 sunny. All rights reserved.
//

import Foundation

/// 扩展数组
extension Array where Element: Equatable {
    
    /// 删除第一个和指定元素相同的数组元素 Remove FIRST collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
    
    /// 删除所有和指定元素相同的数组元素 Remove ALL collection element that is equal to the given `object`:
    mutating func removeAllSame(object: Element) {
        for _ in 0..<self.count {
            if let index = index(of: object) {
                remove(at: index)
            }
        }
    }
}
