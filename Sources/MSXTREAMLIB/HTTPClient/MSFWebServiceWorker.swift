//
//  File.swift
//
//
//  Created by Janita Alice on 31/12/20.
//

import Foundation

public class MSFWebServiceWorker {
    
    public let decoder = JSONDecoder()
    public let encoder = JSONEncoder()
    public let timeInterval: TimeInterval = 35.0
    
    public var requestHttpHeaders = RestEntity()
    public var urlQueryParameters = RestEntity()
    public var httpBodyParameters = RestEntity()
    public var httpBody: Data?
    
    public var logConfig: LogConfig = LogConfig()
    
    public init() {}
    
//    public func sendRequestWithGetMethod<response: DataProvider>(url: String, res: response, successHandler:@escaping (_ jsonData: response) -> Void, failureHandler:@escaping (_ error: BaseError) -> Void) {
//
//        var request = URLRequest(url: NSURL(string: url)! as URL)
//        request.timeoutInterval = timeInterval
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let task = URLSession.shared.dataTask(with: request) { (data, dicResponse, error) -> Void in
//            DispatchQueue.main.async {
//                if let httpResponse = dicResponse as? HTTPURLResponse {
//
//                    if let unwrappedError = error {
//                        failureHandler(self.getReceivedError(message: unwrappedError.localizedDescription))
//                    } else {
//                        if httpResponse.statusCode == 200 {
//                            if let unwrappedData = data {
//
//                                let decodedString = String(data: unwrappedData, encoding: .utf8)!
//                                self.logConfig.printLog(msg: decodedString)
//                                do {
//                                    let res: response = try self.decoder.decode(response.self, from: unwrappedData)
//                                    successHandler(res)
//                                } catch {
//                                    failureHandler(self.getParserError())
//                                }
//                            }
//                        } else {
//                            failureHandler(self.getRequestFailureError())
//                        }
//                    }
//                }
//            }
//            DispatchQueue.main.async {
//                if let unwrappedError = error {
//                    failureHandler(self.getReceivedError(message: unwrappedError.localizedDescription))
//                }
//            }
//        }
//        task.resume()
//
//    }
    
    public func sendRequestWithMethod<response: DataProvider>(url: String, method: HttpMethod, res: response, successHandler:@escaping (_ jsonData: response) -> Void, failureHandler:@escaping (_ error: BaseError) -> Void) {
        
        guard let urlStr = URL(string: url) else { return }
        let targetURL = self.addURLQueryParameters(toURL: urlStr)
        let httpBody = self.getHttpBody()
        
        guard let request = self.prepareRequest(withURL: targetURL, httpBody: httpBody, httpMethod: method) else
        {
            failureHandler(getReceivedError(message: ErrorMsgConfig().no_url_request))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, dicResponse, error) -> Void in
            DispatchQueue.main.async {
                if let httpResponse = dicResponse as? HTTPURLResponse {
                    
                    if let unwrappedError = error {
                        failureHandler(self.getReceivedError(message: unwrappedError.localizedDescription))
                    } else {
                        if httpResponse.statusCode >= 200 || httpResponse.statusCode < 300 {
                            if let unwrappedData = data {
                                
                                let decodedString = String(data: unwrappedData, encoding: .utf8)!
                                self.logConfig.printLog(msg: decodedString)
                                do {
                                    let res: response = try self.decoder.decode(response.self, from: unwrappedData)
                                    successHandler(res)
                                } catch {
                                    failureHandler(self.getParserError())
                                }
                            }
                        } else {
                            failureHandler(self.getRequestFailureError())
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    failureHandler(self.getReceivedError(message: unwrappedError.localizedDescription))
                }
            }
        }
        task.resume()
        
    }
    
    
    func getParserError() -> BaseError {
        
        let errorKSec = BaseError()
        errorKSec.errorType = ErrorTypes.Network
        errorKSec.message = ErrorMsgConfig().parse_failure
        
        return errorKSec
    }
    
    func getRequestFailureError() -> BaseError {
        
        let errorKSec = BaseError()
        errorKSec.errorType = ErrorTypes.Network
        errorKSec.message = ErrorMsgConfig().request_failure
        
        return errorKSec
    }
    
    func getReceivedError(message: String) -> BaseError {
        let errorKSec = BaseError()
        errorKSec.errorType = ErrorTypes.Network
        errorKSec.message =  message
        
        return errorKSec
        
    }
    
    // MARK: - Private Methods
    
    private func addURLQueryParameters(toURL url: URL) -> URL {
        if urlQueryParameters.totalItems() > 0 {
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url }
            var queryItems = [URLQueryItem]()
            for (key, value) in urlQueryParameters.allValues() {
                let item = URLQueryItem(name: key, value: value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                
                queryItems.append(item)
            }
            
            urlComponents.queryItems = queryItems
            
            guard let updatedURL = urlComponents.url else { return url }
            return updatedURL
        }
        
        return url
    }
    
    
    
    private func getHttpBody() -> Data? {
        guard let contentType = requestHttpHeaders.value(forKey: "Content-Type") else { return nil }
        
        if contentType.contains("application/json") {
            return try? JSONSerialization.data(withJSONObject: httpBodyParameters.allValues(), options: [.prettyPrinted])
        } else if contentType.contains("application/x-www-form-urlencoded") {
            let bodyString = httpBodyParameters.allValues().map { "\($0)=\(String(describing: $1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))" }.joined(separator: "&")
            return bodyString.data(using: .utf8)
        } else {
            return httpBody
        }
    }
    
    private func prepareRequest(withURL url: URL?, httpBody: Data?, httpMethod: HttpMethod) -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        for (header, value) in requestHttpHeaders.allValues() {
            request.setValue(value, forHTTPHeaderField: header)
        }
        
        request.httpBody = httpBody
        return request
    }
    
}

public extension MSFWebServiceWorker {
    
    public struct RestEntity {
        private var values: [String: String] = [:]
        
        public mutating func add(value: String, forKey key: String) {
            values[key] = value
        }
        
        public func value(forKey key: String) -> String? {
            return values[key]
        }
        
        public func allValues() -> [String: String] {
            return values
        }
        
        public func totalItems() -> Int {
            return values.count
        }
    }
}

