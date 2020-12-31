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
    public var validatorWorker = ValidatorWorker()
    public let timeInterval: TimeInterval = 35.0
    //    var task:URLSessionDataTask
    
    public init() {}
    
    public func sendRequestWithGetMethod<response: DataProvider>(url: String, res: response, successHandler:@escaping (_ jsonData: response) -> Void, failureHandler:@escaping (_ error: BaseError) -> Void) {
        
        //        var msfResponse = res
        // var msfResponse = BaseResponse<response>()
        var request = URLRequest(url: NSURL(string: url)! as URL)
        request.timeoutInterval = timeInterval
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        ////print("Request URL======\(request)")
        //        task.cancel()
        let task = URLSession.shared.dataTask(with: request) { (data, dicResponse, error) -> Void in
            DispatchQueue.main.async {
                if let httpResponse = dicResponse as? HTTPURLResponse {
                    
                    //Handle Network related errors
                    if let unwrappedError = error {
                        failureHandler(self.getReceivedError(message: unwrappedError.localizedDescription))
                    } else {
                        //Response Received
                        if httpResponse.statusCode == 200 {
                            if let unwrappedData = data {
                                
                                let decodedString = String(data: unwrappedData, encoding: .utf8)!
                                // //print("Response Body======\(decodedString)")
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
                //This block also gives us "API Service is not available." error message sometimes
                if let unwrappedError = error {
                    failureHandler(self.getReceivedError(message: unwrappedError.localizedDescription))
                }
            }
        }
        task.resume()
        
    }
    
    public func sendRequestWithMethod<request: DataProvider, response: DataProvider>(url: String, method: HttpMethod, req: request, isEncryption: Bool, res: response, successHandler:@escaping (_ jsonData: response) -> Void, failureHandler:@escaping (_ error: BaseError) -> Void) {
        
        
        var msfRequest = BaseRequest<request>()
        msfRequest.request = JSONRequestPart<request>()
        msfRequest.request.data = req as? request.ProvidedData
        
        var request = URLRequest(url: NSURL(string: url)! as URL)
        request.timeoutInterval = timeInterval
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method.rawValue
        if let session = AppConfig.shared.sessionID {
            let sessionID = "JSESSIONID="+session
            //            request.addValue(sessionID, forHTTPHeaderField: "Set-Cookie") Cookie
            request.addValue(sessionID, forHTTPHeaderField: "Cookie")
        }
        
        var encodeJSONData: Data?
        do {
            encodeJSONData =  try encoder.encode(msfRequest)
            
            if isEncryption {
                let reqStr = (String(data: encodeJSONData!, encoding: String.Encoding.utf8))
                let encryptData = Crypto.encryptText(key: AppConfig.shared.EncryptionKey!, textStr: reqStr!)
                request.httpBody = encryptData.base64EncodedData()
            } else {
                request.httpBody = encodeJSONData!
            }
            
            print("Request Body======\(String(data: encodeJSONData!, encoding: String.Encoding.utf8)!)")
            
            let task = URLSession.shared.dataTask(with: request) { (data, dicResponse, error) -> Void in
                DispatchQueue.main.async {
                    if let httpResponse = dicResponse as? HTTPURLResponse {
                        //Handle Network related errors
                        if let unwrappedError = error {
                            //                        //print("error====\(unwrappedError)")
                            let errorKSec = BaseError()
                            errorKSec.errorType = ErrorTypes.Network
                            errorKSec.message = unwrappedError.localizedDescription
                            failureHandler(errorKSec)
                        } else {
                            //Response Received
                            if httpResponse.statusCode == 200 {
                                if let unwrap = data {
                                    
                                    var unwrappedData = unwrap
                                    if isEncryption {
                                        if let baseData = Data(base64Encoded: unwrappedData) {
                                            unwrappedData = Crypto.decryptText(key: AppConfig.shared.EncryptionKey!, textData: baseData)
                                        }
                                    }
                                    
                                    let decodedString = String(data: unwrappedData, encoding: .utf8)!
                                    ////print("Response Body======\(decodedString)")
                                    do {
                                        let res = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments)
                                        if let dicRes: NSDictionary = (res as? NSDictionary) {
                                            if let response = dicRes.object(forKey: "response") as? NSDictionary {
                                                if let infoID = response.object(forKey: "infoID") as? String {
                                                    if BaseValidator.isValidResponse(infoID: infoID) {
                                                        if let dicData = response.object(forKey: "data") as? NSDictionary {
                                                            successHandler(dicData as! response)
                                                        }
                                                    } else {
                                                        let errorKSec = BaseError()
                                                        errorKSec.infoID = infoID
                                                        if let message = response.object(forKey: "infoMsg") as? String {
                                                            errorKSec.message = message
                                                        }
                                                        failureHandler(self.validatorWorker.getError(error: errorKSec))
                                                    }
                                                }
                                            }
                                        }
                                    } catch {
                                        let errorKSec = BaseError()
                                        errorKSec.errorType = ErrorTypes.Network
                                        errorKSec.message = "Parse failure"
                                        failureHandler(errorKSec)
                                    }
                                    return
                                }
                            } else {
                                let errorKSec = BaseError()
                                errorKSec.errorType = ErrorTypes.Network
                                errorKSec.message = "Request failure"
                                failureHandler(errorKSec)
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    //This block also gives us "API Service is not available." error message sometimes
                    if let unwrappedError = error {
                        let errorKSec = BaseError()
                        errorKSec.errorType = ErrorTypes.Network
                        errorKSec.message = unwrappedError.localizedDescription
                        failureHandler(errorKSec)
                    }
                }
            }
            task.resume()
            
        } catch {
            let errorKSec = BaseError()
            errorKSec.errorType = ErrorTypes.Parsing
            errorKSec.message = error.localizedDescription
            failureHandler(errorKSec)
            //            //print(error.localizedDescription)
        }
    }
    
    
    func getParserError() -> BaseError {
        
        let errorKSec = BaseError()
        errorKSec.errorType = ErrorTypes.Network
        errorKSec.message = "Parse failure"
        
        return errorKSec
    }
    
    func getRequestFailureError() -> BaseError {
        
        let errorKSec = BaseError()
        errorKSec.errorType = ErrorTypes.Network
        errorKSec.message = "Request failure"
        
        return errorKSec
    }
    
    func getReceivedError(message: String) -> BaseError {
        let errorKSec = BaseError()
        errorKSec.errorType = ErrorTypes.Network
        errorKSec.message =  message
        
        return errorKSec
        
    }
    
    /// Response in class Format
    public func sendRequest<request: DataProvider, response: DataProvider>(req: request, res: response, isEncryption: Bool, successHandler:@escaping (_ jsonData: response.ProvidedData?) -> Void, failureHandler:@escaping (_ error: BaseError) -> Void) {
        return sendRequest(req: req, res: res, isEncryption: isEncryption, successHandler: { (jsonData, _) in
            successHandler(jsonData)
        }) { (error) in
            failureHandler(error)
        }
    }
    
    /// response with Dictionary
    public func sendRequest<request: DataProvider>(req: request, isEncryption: Bool, successHandler:@escaping (_ dictData: NSDictionary?) -> Void, failureHandler:@escaping (_ error: BaseError) -> Void) {
        
        var msfRequest = BaseRequest<request>()
        //        var msfResponse = BaseResponse<response>()
        
        msfRequest.request = JSONRequestPart<request>()
        //        req.accID1 = ""
        msfRequest.request.data = req as? request.ProvidedData
        
        guard let url = AppConfig.shared.getURL else {
            return
        }
        let  finalURL = url+"/"+req.getServletGroup()+"/"+req.getServletName()+"/"+req.getServletVersion()
        var request = URLRequest(url: NSURL(string: finalURL)! as URL)
        request.timeoutInterval = timeInterval
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //        request.addValue("gzip", forHTTPHeaderField: "Content-Encoding")
        //        request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        if let session = AppConfig.shared.sessionID {
            let sessionID = "JSESSIONID="+session
            //            request.addValue(sessionID, forHTTPHeaderField: "Set-Cookie") Cookie
            request.addValue(sessionID, forHTTPHeaderField: "Cookie")
        }
        // request.addValue(KSecDataManager.sharedInstance.sessionID ?? "", forHTTPHeaderField: "Set-Cookie")
        request.httpMethod = "POST"
        
        var encodeJSONData: Data?
        do {
            encodeJSONData =  try encoder.encode(msfRequest)
            
            if isEncryption {
                let reqStr = (String(data: encodeJSONData!, encoding: String.Encoding.utf8))
                let encryptData = Crypto.encryptText(key: AppConfig.shared.EncryptionKey!, textStr: reqStr!)
                request.httpBody = encryptData.base64EncodedData()
            } else {
                request.httpBody = encodeJSONData!
            }
            
            print("Request URL======\(finalURL)")
            print("Request Body======\(String(data: encodeJSONData!, encoding: String.Encoding.utf8)!)")
            
            let task = URLSession.shared.dataTask(with: request) { (data, dicResponse, error) -> Void in
                DispatchQueue.main.async {
                    if let httpResponse = dicResponse as? HTTPURLResponse {
                        //Handle Network related errors
                        if let unwrappedError = error {
                            //                        //print("error====\(unwrappedError)")
                            let errorKSec = BaseError()
                            errorKSec.errorType = ErrorTypes.Network
                            errorKSec.message = unwrappedError.localizedDescription
                            failureHandler(errorKSec)
                        } else {
                            //Response Received
                            if httpResponse.statusCode == 200 {
                                if let unwrap = data {
                                    
                                    var unwrappedData = unwrap
                                    if isEncryption {
                                        if let baseData = Data(base64Encoded: unwrappedData) {
                                            unwrappedData = Crypto.decryptText(key: AppConfig.shared.EncryptionKey!, textData: baseData)
                                        }
                                    }
                                    
                                    let decodedString = String(data: unwrappedData, encoding: .utf8)!
                                    ////print("Response Body======\(decodedString)")
                                    do {
                                        let res = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments)
                                        if let dicRes: NSDictionary = (res as? NSDictionary) {
                                            if let response = dicRes.object(forKey: "response") as? NSDictionary {
                                                if let infoID = response.object(forKey: "infoID") as? String {
                                                    if BaseValidator.isValidResponse(infoID: infoID) {
                                                        if let dicData = response.object(forKey: "data") as? NSDictionary {
                                                            successHandler(dicData)
                                                        }
                                                    } else {
                                                        let errorKSec = BaseError()
                                                        errorKSec.infoID = infoID
                                                        if let message = response.object(forKey: "infoMsg") as? String {
                                                            errorKSec.message = message
                                                        }
                                                        failureHandler(self.validatorWorker.getError(error: errorKSec))
                                                    }
                                                }
                                            }
                                        }
                                    } catch {
                                        let errorKSec = BaseError()
                                        errorKSec.errorType = ErrorTypes.Network
                                        errorKSec.message = "Parse failure"
                                        failureHandler(errorKSec)
                                    }
                                    return
                                }
                            } else {
                                let errorKSec = BaseError()
                                errorKSec.errorType = ErrorTypes.Network
                                errorKSec.message = "Request failure"
                                failureHandler(errorKSec)
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    //This block also gives us "API Service is not available." error message sometimes
                    if let unwrappedError = error {
                        let errorKSec = BaseError()
                        errorKSec.errorType = ErrorTypes.Network
                        errorKSec.message = unwrappedError.localizedDescription
                        failureHandler(errorKSec)
                    }
                }
            }
            task.resume()
            
        } catch {
            let errorKSec = BaseError()
            errorKSec.errorType = ErrorTypes.Parsing
            errorKSec.message = error.localizedDescription
            failureHandler(errorKSec)
            //            //print(error.localizedDescription)
        }
    }
    
    /// Response in class Format with  server Time
    public func sendRequest<request: DataProvider, response: DataProvider>(req: request, res: response, isEncryption: Bool, successHandler:@escaping (_ jsonData: response.ProvidedData?, _ serverTime: String?) -> Void, failureHandler:@escaping (_ error: BaseError) -> Void) {
        
        var msfRequest = BaseRequest<request>()
        var msfResponse = BaseResponse<response>()
        
        msfRequest.request = JSONRequestPart<request>()
        msfRequest.request.data = req as? request.ProvidedData
        
        guard let url = AppConfig.shared.getURL else {
            return
        }
        let finalURL = url+"/"+req.getServletGroup()+"/"+req.getServletName()+"/"+req.getServletVersion()
        //        let finalURL = "http://localhost/root/" + req.getServletGroup() + "/" + req.getServletName() + "/example/" + req.getServletGroup() + "_" + req.getServletName()+"_" + req.getServletVersion() + ".json"
        var request = URLRequest(url: NSURL(string: finalURL)! as URL)
        request.timeoutInterval = timeInterval
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.addValue("gzip", forHTTPHeaderField: "Content-Encoding")
        // request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        if let session = AppConfig.shared.sessionID {
            let sessionID = "JSESSIONID="+session
            //            request.addValue(sessionID, forHTTPHeaderField: "Set-Cookie") Cookie
            request.addValue(sessionID, forHTTPHeaderField: "Cookie")
        }
        
        request.httpMethod = "POST"
        
        var encodeJSONData: Data?
        do {
            encodeJSONData =  try encoder.encode(msfRequest)
            
            if isEncryption {
                let reqStr = (String(data: encodeJSONData!, encoding: String.Encoding.utf8))
                let encryptData = Crypto.encryptText(key: AppConfig.shared.EncryptionKey!, textStr: reqStr!)
                request.httpBody = encryptData.base64EncodedData()
            } else {
                request.httpBody = encodeJSONData!
            }
            
            //            //print("Request URL======\(finalURL)")
            //            //print("Request Body======\(String(data: encodeJSONData!, encoding: String.Encoding.utf8)!)")
            
            let task = URLSession.shared.dataTask(with: request) { (data, dicResponse, error) -> Void in
                DispatchQueue.main.async {
                    if let httpResponse = dicResponse as? HTTPURLResponse {
                        //Handle Network related errors
                        if let unwrappedError = error {
                            //                        //print("error====\(unwrappedError)")
                            let errorKSec = BaseError()
                            errorKSec.errorType = ErrorTypes.Network
                            errorKSec.message = unwrappedError.localizedDescription
                            failureHandler(errorKSec)
                        } else {
                            //Response Received
                            if httpResponse.statusCode == 200 {
                                if let unwrap = data {
                                    
                                    var unwrappedData = unwrap
                                    if isEncryption {
                                        //let decodedString = String(data: unwrappedData, encoding: .utf8)!
                                        if let baseData = Data(base64Encoded: unwrappedData) {
                                            unwrappedData = Crypto.decryptText(key: AppConfig.shared.EncryptionKey!, textData: baseData)
                                        }
                                    }
                                    let decodedString = String(data: unwrappedData, encoding: .utf8)
                                    if decodedString == nil
                                    {
                                        let errorKSec = BaseError()
                                        errorKSec.errorType = ErrorTypes.Network
                                        errorKSec.message = "Empty response"
                                        failureHandler(errorKSec)
                                    }
                                    else
                                    {
                                        let decodedString = String(data: unwrappedData, encoding: .utf8)!
                                        print("Response Body======\(decodedString)")
                                        do {
                                            msfResponse = try self.decoder.decode(BaseResponse.self, from: unwrappedData)
                                            
                                            let responseKey = res.getServletName()+res.getServletGroup()+"_Response"
                                            
                                            let isValidResponse = BaseValidator.isValidResponse(infoID: (msfResponse.response.infoID)!)
                                            if isValidResponse == true {
                                                
                                                successHandler(msfResponse.response.data, msfResponse.response.serverTime)
                                            } else {
                                                
                                                let errorKSec = BaseError()
                                                
                                                if let infoID = msfResponse.response.infoID {
                                                    errorKSec.infoID = infoID
                                                }
                                                if let message = msfResponse.response.infoMsg {
                                                    errorKSec.message = message
                                                }
                                                
                                                failureHandler(self.validatorWorker.getError(error: errorKSec))
                                            }
                                        } catch {
                                            let errorKSec = BaseError()
                                            errorKSec.errorType = ErrorTypes.Network
                                            errorKSec.message = "Parse failure"
                                            failureHandler(errorKSec)
                                        }
                                    }
                                }
                            } else {
                                let errorKSec = BaseError()
                                errorKSec.errorType = ErrorTypes.Network
                                errorKSec.message = "Request failure"
                                failureHandler(errorKSec)
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    //This block also gives us "API Service is not available." error message sometimes
                    if let unwrappedError = error {
                        let errorKSec = BaseError()
                        errorKSec.errorType = ErrorTypes.Network
                        errorKSec.message = unwrappedError.localizedDescription
                        failureHandler(errorKSec)
                    }
                }
            }
            task.resume()
        } catch {
            let errorKSec = BaseError()
            errorKSec.errorType = ErrorTypes.Parsing
            errorKSec.message = error.localizedDescription
            failureHandler(errorKSec)
            //            //print(error.localizedDescription)
        }
    }
    /*
     NSDictionary *d = [cookie splitNameValues:[NSCharacterSet characterSetWithCharactersInString:@"=;"] andPerform:NULL inContext:NULL];
     NSString *sessionID = [d objectForKey:@"JSESSIONID"];
     
     */
    
    func getSessionFromString(sessionStr: String) -> String {
        let sessionStrArray = sessionStr.components(separatedBy: ";")
        let JSessionID = sessionStrArray[0].components(separatedBy: "=")
        return JSessionID[1]
    }
    
    //    func sendRequest<reqData:DataProvider, resData:DataProvider>(req:BaseRequest<reqData>, successHandler:@escaping (_ baseResponse: BaseResponse<resData>?) -> Void, failureHandler:@escaping (_ error: BaseError) -> Void) {
    //
    //    }
}

extension MSFWebServiceWorker {
    /*
     
     keys Last_Request, Last_Response
     
     [CrashlyticsKit setObjectValue:[NSString stringWithFormat:@"%@%@_Request",[classRequest getServletName],[classRequest getServletGroup]] forKey:NSLocalizedString(@"FIREBASE_SERVICE", nil)];
     CLS_LOG(@"Requesting %@", [NSString stringWithFormat:@"%@%@",[classRequest getServletName],[classRequest getServletGroup]]);
     */
    private func getFormattedObjectRequset<request: DataProvider>(req: request) -> String {
        return req.getServletName()+req.getServletGroup()+"_Request"
    }
    
}
