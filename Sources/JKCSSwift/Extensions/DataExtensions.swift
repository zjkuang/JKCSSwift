//
//  DataExtensions.swift
//  JKCSSwift
//
//  Created by Zhengqian Kuang on 2020-06-24.
//

import Foundation

public extension Data {
    func write(filename: String, relativePath: String? = nil, baseDirectory: FileManager.SearchPathDirectory) -> Result<ExpressibleByNilLiteral?, JKCSError> {
        guard var url = FileManager.default.urls(for: baseDirectory, in: .userDomainMask).first else {
            return Result.failure(.customError(message: "Failed to get base directory."))
        }
        if let relativePath = relativePath {
            url.appendPathComponent(relativePath)
        }
        url.appendPathComponent(filename)
        do {
            try write(to: url, options: .atomic)
            return Result.success(nil)
        } catch {
            return Result.failure(.customError(message: error.localizedDescription))
        }
    }
    
    static func read(filename: String, relativePath: String? = nil, baseDirectory: FileManager.SearchPathDirectory) -> Result<Self?, JKCSError> {
        guard var url = FileManager.default.urls(for: baseDirectory, in: .userDomainMask).first else {
            return Result.failure(.customError(message: "Failed to get base directory."))
        }
        if let relativePath = relativePath {
            url.appendPathComponent(relativePath)
        }
        url.appendPathComponent(filename)
        do {
            let data = try Data(contentsOf: url)
            return Result.success(data)
        } catch {
            return Result.success(nil)
        }
    }
}
