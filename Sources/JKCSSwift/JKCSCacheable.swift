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
    @discardableResult func save(key: String, group: String? = nil, storage: JKCSStorageType = .file) -> Result<ExpressibleByNilLiteral?, JKCSError> {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(self)
            
            switch storage {
            case .userDefaults:
                UserDefaults.standard.set(data, forKey: key)
                return Result.success(nil)
                
            case .file:
                let path: String
                if let group = group,
                    group.count > 0 {
                    path = "\(cacheDirectory)/\(group)"
                }
                else {
                    path = cacheDirectory
                }
                return data.write(path: path, filename: key)
                
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
    
    static func retrieve<T: JKCSCacheable>(key: String, group: String? = nil, storage: JKCSStorageType = .file) -> Result<T?, JKCSError> {
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
            let path: String
            if let group = group,
                group.count > 0 {
                path = "\(cacheDirectory)/\(group)"
            }
            else {
                path = cacheDirectory
            }
            let result = Data.read(path: path, filename: key)
            switch result {
            case .failure(let error):
                return Result.failure(error)
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let instance = try decoder.decode(T.self, from: data)
                    return Result.success(instance)
                }
                catch {
                    return Result.failure(JKCSError.customError(message: "Failed to decode"))
                }
            }
                
        // case .keychain:
            // to be added
        }
    }
    
    static func clearFromStorage(key: String, group: String? = nil, storage: JKCSStorageType = .file) {
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
