//
//  JKCSCacheable.swift
//  JKCSSwift
//
//  Created by Zhengqian Kuang on 2020-06-15.
//  Copyright © 2020 Kuang. All rights reserved.
//

import Foundation

fileprivate let cacheDirectory = "JKCSCache"

public enum JKCSStorageType: String {
    case userDefaults
    case file
    // case keychain // To be added, for confidential information
}

public enum JKCSCacheLookupResult {
    case abnormal
    case miss, hit
}

public protocol JKCSCacheable: Codable {
    @discardableResult func save(key: String, group: String?, storage: JKCSStorageType) -> Result<ExpressibleByNilLiteral?, JKCSError>
    
    static func retrieve<T: JKCSCacheable>(key: String, group: String?, storage: JKCSStorageType) -> Result<T?, JKCSError>
    
    static func clearFromStorage(key: String, group: String?, storage: JKCSStorageType)
}

public extension JKCSCacheable {
    @discardableResult func save(key: String, group: String = "default", storage: JKCSStorageType = .file) -> Result<ExpressibleByNilLiteral?, JKCSError> {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(self)
            
            switch storage {
            case .userDefaults:
                UserDefaults.standard.set(data, forKey: key)
                return Result.success(nil)
                
            case .file:
                let path = "\(cacheDirectory)/\(group)"
                let result = JKCSFile.createDirectory(atRelativePath: path, baseDirectory: .cachesDirectory)
                switch result {
                case .failure(let error):
                    return Result.failure(error)
                case .success(_):
                    return data.write(filename: key, relativePath: path, baseDirectory: .cachesDirectory)
                }
                
            // case .keychain:
                // to be added
            }
        }
        catch {
            let errorMessage = "Failed to encode."
            print("Saving cachable (key: \(key)) failed. \(errorMessage)")
            return Result.failure(JKCSError.customError(message: errorMessage))
        }
    }
    
    static func retrieve<T: JKCSCacheable>(key: String, group: String = "default", storage: JKCSStorageType = .file) -> Result<T?, JKCSError> {
        switch storage {
        case .userDefaults:
            guard let data = UserDefaults.standard.data(forKey: key) else {
                return Result.success(nil)
            }
            let decoder = JSONDecoder()
            do {
                let instance = try decoder.decode(T.self, from: data)
                return Result.success(instance)
            }
            catch {
                return Result.failure(JKCSError.customError(message: "Failed to decode"))
            }
            
        case .file:
            let path = "\(cacheDirectory)/\(group)"
            let result = Data.read(filename: key, relativePath: path, baseDirectory: .cachesDirectory)
            switch result {
            case .failure(let error):
                return Result.failure(error)
            case .success(let data):
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let instance = try decoder.decode(T.self, from: data)
                        return Result.success(instance)
                    }
                    catch {
                        return Result.failure(JKCSError.customError(message: "Failed to decode"))
                    }
                }
                else {
                    return Result.success(nil)
                }
            }
                
        // case .keychain:
            // to be added
        }
    }
    
    static func clearFromStorage(key: String, group: String = "default", storage: JKCSStorageType = .file) {
        switch storage {
        case .userDefaults:
            UserDefaults.standard.removeObject(forKey: key)
            
        case .file:
            break
                
        // case .keychain:
            // to be added
        }
    }
}
