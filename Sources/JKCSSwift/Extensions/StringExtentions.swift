//
//  StringExtentions.swift
//  JKCSSwift
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
    
    func write(path: String? = nil, filename: String) -> Result<ExpressibleByNilLiteral?, JKCSError> {
        guard let data = data(using: .utf8) else {
            return Result.failure(.customError(message: "Failed to convert to data using UTF8."))
        }
        return data.write(path: path, filename: filename)
    }
    
    static func read(path: String? = nil, filename: String) -> Result<Self, JKCSError> {
        let result = Data.read(path: path, filename: filename)
        switch result {
        case .failure(let error):
            return Result.failure(error)
        case .success(let data):
            if let str = String(data: data, encoding: .utf8) {
                return Result.success(str)
            }
            else {
                return Result.failure(.customError(message: "Failed to decode data using UTF8."))
            }
        }
    }
}
