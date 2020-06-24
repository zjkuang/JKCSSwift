//
//  DataExtensions.swift
//  JKCSSwift
//
//  Created by Zhengqian Kuang on 2020-06-24.
//

import Foundation

public extension Data {
    func write(path: String? = nil, filename: String) -> Result<ExpressibleByNilLiteral?, JKCSError> {
        guard var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return Result.failure(.customError(message: "Failed to get Document directory."))
        }
        if let path = path {
            url.appendPathComponent(path)
        }
        url.appendPathComponent(filename)
        do {
            try write(to: url, options: .atomic)
            return Result.success(nil)
        } catch {
            return Result.failure(.customError(message: "Failed to write data"))
        }
    }
    
    static func read(path: String? = nil, filename: String) -> Result<Self, JKCSError> {
        guard var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return Result.failure(.customError(message: "Failed to get Document directory."))
        }
        if let path = path {
            url.appendPathComponent(path)
        }
        url.appendPathComponent(filename)
        do {
            let data = try Data(contentsOf: url)
            return Result.success(data)
        } catch {
            return Result.failure(.customError(message: "Failed to read from file."))
        }
    }
}
