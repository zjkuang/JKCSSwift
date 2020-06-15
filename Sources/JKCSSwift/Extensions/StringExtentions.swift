//
//  StringExtentions.swift
//  Practice001
//
//  Created by Zhengqian Kuang on 2020-06-13.
//  Copyright © 2020 Kuang. All rights reserved.
//

import Foundation

public extension String {
    func toJSONObject() -> Any? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        return jsonObject
    }
}
