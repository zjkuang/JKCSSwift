//
//  JKCSMisc.swift
//  Practice001
//
//  Created by Zhengqian Kuang on 2020-06-16.
//  Copyright © 2020 Kuang. All rights reserved.
//

import Foundation
import UIKit

public enum JKCSJPEGQuality: CGFloat {
    case lowest  = 0
    case low     = 0.25
    case medium  = 0.5
    case high    = 0.75
    case highest = 1
}

public extension Data {
    func compressImageData(qualities: [JKCSJPEGQuality], completionHandler: @escaping ([Self?]) -> ()) {
        DispatchQueue.global(qos: .background).async {
            var result: [Self?] = []
            for quality in qualities {
                let data = UIImage(data: self)?.jpegData(compressionQuality: quality.rawValue)
                result.append(data)
            }
            DispatchQueue.main.async {
                completionHandler(result)
            }
        }
    }
}
