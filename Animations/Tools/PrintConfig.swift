//
//  Print.swift
//  EFParents
//
//  Created by yuency on 17/08/2017.
//  Copyright © 2017 yuency. All rights reserved.
//

import Foundation


/// Custom Print Location
///
/// - Parameters:
///   - message: input your message
///   - file: file
///   - method: method
///   - line: line
func printLog<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
        print("\n 📍类名:\((file as NSString).lastPathComponent), 方法名:\(method), 行号:\(line), 其他信息: \(message) \n")
    #endif
}


/// Custom Print Thread
func printInThread() {
    #if DEBUG
        print( "\n ** MainThread: \(Thread.main), \n ** CurrentThread: \(Thread.current), \n ** InMain: \(Thread.isMainThread) \n")
    #endif
}
