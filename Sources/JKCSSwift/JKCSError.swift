//
//  JKCSError.swift
//  JKCSSwift
//
//  Created by Zhengqian Kuang on 2020-06-13.
//

import Foundation

public enum JKCSError: Error {
    case noError(message: String = "No error")
    case genericError(message: String = "Generic error")
    case customError(message: String)
    case restServiceError((code: Int, message: String))
    
    public var code: Int? {
        switch self {
        case .customError, .genericError, .noError:
            return nil
        case .restServiceError((let code, _)):
            return code
        }
    }
    
    public var message: String {
        switch self {
        case .customError(let msg), .genericError(let msg), .noError(let msg):
            return msg
        case .restServiceError((_, let msg)):
            return msg
        }
    }
}
