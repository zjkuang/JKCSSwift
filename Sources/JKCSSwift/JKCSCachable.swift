//
//  JKCSCachable.swift
//  Practice001
//
//  Created by Zhengqian Kuang on 2020-06-15.
//  Copyright © 2020 Kuang. All rights reserved.
//

import Foundation

public enum JKCSStorageType: String {
    case userDefaults
    // case keychain // For confidential information
}

public enum JKCSCacheLookupResult {
    case abnormal
    case miss, hit
}

public protocol JKCSCachable: Codable {
    @discardableResult func save(key: String, storage: JKCSStorageType) -> Result<ExpressibleByNilLiteral?, JKCSError>
    
    static func retrieve<T: JKCSCachable>(key: String, storage: JKCSStorageType) -> Result<T?, JKCSError>
    
    static func clearFromStorage(key: String, storage: JKCSStorageType)
}

public extension JKCSCachable {
    @discardableResult func save(key: String, storage: JKCSStorageType = .userDefaults) -> Result<ExpressibleByNilLiteral?, JKCSError> {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(self)
            
            switch storage {
            case .userDefaults:
                UserDefaults.standard.set(data, forKey: key)
                return Result.success(nil)
                
            // case .keychain:
                //
            }
        }
        catch {
            let errorMessage = "Failed to encode."
            print("Saving cachable (key: \(key)) failed. \(errorMessage)")
            return Result.failure(JKCSError.customError(message: errorMessage))
        }
    }
    
    static func retrieve<T: JKCSCachable>(key: String, storage: JKCSStorageType = .userDefaults) -> Result<T?, JKCSError> {
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
                
        // case .keychain:
            //
        }
    }
    
    static func clearFromStorage(key: String, storage: JKCSStorageType = .userDefaults) {
        switch storage {
        case .userDefaults:
            UserDefaults.standard.removeObject(forKey: key)
                
        // case .keychain:
            //
        }
    }
}
