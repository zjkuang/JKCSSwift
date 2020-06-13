//
//  JKCSNetworkService.swift
//  JKCSSwift
//
//  Created by Zhengqian Kuang on 2020-06-13.
//

import Foundation

public class JKCSNetworkService {
    
    public static let shared = JKCSNetworkService()
    
    public init() {}
    
    public enum HTTPMethod: String {
        case GET, POST, PUT, DELETE
    }
    
    public func dataTask(method: HTTPMethod, url: String, body: [String : Any]? = nil, httpHeaders: [String : String]? = nil, completionHandler: @escaping (Result<Any, JKCSError>) -> ()) {
        guard let url = URL(string: url) else {
            completionHandler(Result.failure(.customError(message: "Invalid URL string.")))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        var headers = httpHeaders ?? [:]
        if headers["content-type"] == nil {
            headers["content-type"] = "application/json"
        }
        for (field, value) in headers {
            request.addValue(value, forHTTPHeaderField: field)
        }
        if let body = body,
            body.count > 0 {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                completionHandler(Result.failure(.customError(message: "Invalid body type")))
                return
            }
        }
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse else {
                    completionHandler(Result.failure(.customError(message: "Invalid response type")))
                    return
                }
                guard (200..<300).contains(response.statusCode) else {
                    completionHandler(Result.failure(.restServiceError((code: response.statusCode, message: "HTTP status code"))))
                    return
                }
                if let data = data,
                    let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                    completionHandler(Result.success(jsonObject))
                }
                else {
                    completionHandler(Result.failure(.customError(message: "Unrecogized data format.")))
                    return
                }
            }
        })
        task.resume()
    }
}
