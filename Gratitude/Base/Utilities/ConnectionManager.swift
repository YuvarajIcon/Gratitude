//
//  ConnectionManager.swift
//  Gratitude
//
//  Created by Yuvaraj on 20/09/22.
//

import Foundation
import Promises

enum HTTPMethod {
    case get
    case post
}

enum AppError: Error, Equatable {
    case unknownError
    case connectionError
    case invalidToken
    case invalidRequest
    case notFound
    case invalidResponse
    case serverError
    case serverUnavailable
    case timeOut
    case toomuchRequest
    case unsuppotedURL
    case customError(message: String)
    
    func message() -> String {
        switch self {
        case .customError(let message):
            return message
        default: return ""
        }
    }
}

struct RequestConfig {
    var url: URL
    var method: HTTPMethod = .get
    var parameters: [String: String]?
    var headerDict: [String: String]?
    var fileData: Data?
    var fileFieldName: String?
    var isPublic = false

    init(url:URL) {
        self.url = url;
    }
}

class ConnectionManager {
    private let PEXELS_API_KEY = "563492ad6f917000010000011142b79c1ca541b29c35fcec3164ab0d"
    private static var sharedInstance: ConnectionManager?
    class var shared: ConnectionManager {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance = ConnectionManager()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        return sharedInstance
    }
    
    class func deinitializeSharedInstance() {
        sharedInstance = nil
    }
    
    func connect<T: Codable>(config: RequestConfig) -> Promise<T> {
        var request = URLRequest(url: config.url)
        switch config.method {
        case .post:
            request.httpMethod = "POST"
        default:
            request.httpMethod = "GET"
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let params = config.parameters, let paramData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) {
            request.httpBody = paramData
        }
        request.timeoutInterval = 15
        
        if config.headerDict != nil {
            for (aKey,aValue) in config.headerDict! {
                request.addValue(aValue, forHTTPHeaderField: aKey)
            }
        }
        return Promise<T> { fulfill, reject in
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    reject(error)
                } else if let data = data {
                    guard let response = response as? HTTPURLResponse else {
                        return reject(AppError.unknownError)
                    }
                    guard response.isOK else {
                        return reject(AppError.toomuchRequest)
                    }
                    do {
                        let value = try JSONDecoder().decode(T.self, from: data)
                        fulfill(value)
                    } catch {
                        reject(error)
                    }
                }
            }.resume()
        }
    }
    
    func searchPexel(for searchTerm: String, count amount: Int) -> Promise<PexelSearchResult> {
        let trimmedTerm = searchTerm.replacingOccurrences(of: " ", with: "_")
        var request = RequestConfig(url: URL(string: "https://api.pexels.com/v1/search?query=\(trimmedTerm)&per_page=\(amount)")!)
        request.headerDict = [
            "Authorization": PEXELS_API_KEY
        ]
        return ConnectionManager.shared.connect(config: request)
    }
    
    func nextPexelPage(url: String) -> Promise<PexelSearchResult> {
        var request = RequestConfig(url: URL(string: url)!)
        request.headerDict = [
            "Authorization": PEXELS_API_KEY
        ]
        return ConnectionManager.shared.connect(config: request)
    }
}
