//
//  JKCSFile.swift
//  JKCSSwift
//
//  Created by Zhengqian Kuang on 2020-06-24.
//

import Foundation

public class JKCSFile {
    public static func documentDirectory() -> URL? {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.first
    }
    
    public static func write(data: Data, path: String? = nil, filename: String) -> Result<ExpressibleByNilLiteral?, JKCSError> {
        guard var url = documentDirectory() else {
            return Result.failure(.customError(message: "Failed to get Document directory."))
        }
        if let path = path {
            url.appendPathComponent(path)
        }
        url.appendPathComponent(filename)
        do {
            try data.write(to: url, options: .atomic)
            return Result.success(nil)
        } catch {
            return Result.failure(.customError(message: "Failed to write data"))
        }
    }
}
