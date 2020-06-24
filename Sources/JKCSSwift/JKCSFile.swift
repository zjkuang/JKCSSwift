//
//  JKCSFile.swift
//  JKCSSwift
//
//  Created by Zhengqian Kuang on 2020-06-24.
//

import Foundation

public class JKCSFile {
    public static func baseDirectoryURL(baseDirectory: FileManager.SearchPathDirectory) -> URL? {
        let urls = FileManager.default.urls(for: baseDirectory, in: .userDomainMask)
        return urls.first
    }
    
    public static func fileExists(atRelativePath: String, baseDirectory: FileManager.SearchPathDirectory) -> Bool {
        guard var url = baseDirectoryURL(baseDirectory: baseDirectory) else {
            return false
        }
        url.appendPathComponent(atRelativePath)
        let result = FileManager.default.fileExists(atPath: url.absoluteString)
        return result
    }
    
    public static func isDirectoryAtPath(atRelativePath: String, baseDirectory: FileManager.SearchPathDirectory) -> Bool {
        guard var url = baseDirectoryURL(baseDirectory: baseDirectory) else {
            return false
        }
        url.appendPathComponent(atRelativePath)
        var isDir : ObjCBool = false
        let result = FileManager.default.fileExists(atPath: url.absoluteString, isDirectory: &isDir)
        return (result && isDir.boolValue)
    }
    
    public static func createDirectory(atRelativePath: String, baseDirectory: FileManager.SearchPathDirectory) -> Result<URL, JKCSError> {
        guard var url = baseDirectoryURL(baseDirectory: baseDirectory) else {
            return Result.failure(.customError(message: "Base directory not found."))
        }
        url.appendPathComponent(atRelativePath)
        if isDirectoryAtPath(atRelativePath: atRelativePath, baseDirectory: baseDirectory) {
            return Result.success(url)
        }
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            return Result.success(url)
        } catch {
            return Result.failure(.customError(message: error.localizedDescription))
        }
    }
}
