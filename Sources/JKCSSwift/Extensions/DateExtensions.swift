//
//  DateExtensions.swift
//  JKCSSwift
//
//  Created by Zhengqian Kuang on 2020-06-16.
//  Copyright © 2020 Kuang. All rights reserved.
//

import Foundation

public extension Date {
    func yyyyMMddHHmmss() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = formatter.string(from: self)
        return str
    }
    
    func yyyyMMddHHmmssSSS() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let str = formatter.string(from: self)
        return str
    }
    
    func yyyyMMdd() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let str = formatter.string(from: self)
        return str
    }
}
