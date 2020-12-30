//
//  RestCustomTypes.swift
//  Binary Streaming
//
//  Created by Janita Alice on 29/12/20.
//

import Foundation

public extension RestManager {
    
    enum HttpMethod: String {
        case get
        case post
        case put
        case patch
        case delete
    }
    
    struct RestEntity {
        private var values: [String: String] = [:]
        
        mutating func add(value: String, forKey key: String) {
            values[key] = value
        }
        
        func value(forKey key: String) -> String? {
            return values[key]
        }
        
        func allValues() -> [String: String] {
            return values
        }
        
        func totalItems() -> Int {
            return values.count
        }
    }
    
    
    
    struct Response {
        public var response: URLResponse?
        public var httpStatusCode: Int = 0
        public var headers = RestEntity()
        
        public init(fromURLResponse response: URLResponse?) {
            guard let response = response else { return }
            self.response = response
            httpStatusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            
            if let headerFields = (response as? HTTPURLResponse)?.allHeaderFields {
                for (key, value) in headerFields {
                    headers.add(value: "\(value)", forKey: "\(key)")
                }
            }
        }
    }
    
    struct Results {
        public var data: Data?
        public var response: Response?
        public var error: Error?
        
        public init(withData data: Data?, response: Response?, error: Error?) {
            self.data = data
            self.response = response
            self.error = error
        }
        
        public init(withError error: Error) {
            self.error = error
        }
    }
    
    enum CustomError: Error {
        case failedToCreateRequest
    }
    
}


extension RestManager.CustomError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .failedToCreateRequest: return NSLocalizedString(ErrorMsgConfig().no_url_request, comment: "")
        }
    }
}
