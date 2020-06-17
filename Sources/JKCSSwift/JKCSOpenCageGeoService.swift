//
//  JKCSOpenCageGeoService.swift
//  Practice001
//
//  Created by Zhengqian Kuang on 2020-06-13.
//  Copyright © 2020 Kuang. All rights reserved.
//

import Foundation

/// Warning: This key was generated for public demo purpose. If the key is private, make sure to put it in a separate file and use git-crypt to encrypt it before pushing.
let magic = "883080d0d4203df9f6f48b65b3184288"

open class JKCSOpenCageGeoService {
    public init() {}
    
    public static func map(latitude: String, longitude: String, completionHander: @escaping (Result<[String : Any], JKCSError>) -> ()) {
        let key = String(magic.reversed())
        let url = "https://api.opencagedata.com/geocode/v1/json?q=\(latitude)+\(longitude)&key=\(key)&pretty=1&no_annotations=1"
        JKCSNetworkService.shared.dataTask(method: .GET, url: url) { (result) in
            switch result {
            case .failure(let error):
                completionHander(Result.failure(error))
                return
            case .success(let result):
                if let result = result as? [String : Any] {
                    completionHander(Result.success(result))
                    return
                }
                else {
                    completionHander(Result.failure(.customError(message: "Unknown result format")))
                    return
                }
            }
        }
    }
    
    public static func mapFormatted(latitude: String, longitude: String, completionHander: @escaping (Result<String, JKCSError>) -> ()) {
        map(latitude: latitude, longitude: longitude) { (result) in
            switch result {
            case .failure(let error):
                completionHander(Result.failure(error))
                return
            case .success(let result):
                if let formatted = parseMapLocation(result: result) {
                    completionHander(Result.success(formatted))
                    return
                }
                else {
                    completionHander(Result.failure(.customError(message: "Map location result parsing failed.")))
                    return
                }
            }
        }
    }
    
    private static func parseMapLocation(result: [String : Any]) -> String? {
        guard
            let status = result["status"] as? [String : Any],
            let code = status["code"] as? Int,
            code == 200,
            let results = result["results"] as? [[String : Any]],
            let firstResult = results.first,
            let formatted = firstResult["formatted"] as? String
        else {
            return nil
        }
        return formatted
    }
}
