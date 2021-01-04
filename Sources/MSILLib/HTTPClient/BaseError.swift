//
//  File.swift
//  
//
//  Created by Janita Alice on 31/12/20.
//

import Foundation

public enum ErrorTypes {
    case Network
    case Server
    case InvalidSession
    case Parsing
    case None
}

public enum ErrorDisplayTypes: Int {
    case kErrorActionTypeNone = 0,
    kErrorActionTypeOK = 50,
    kErrorActionTypeMessageWithYESorNO = 51,
    kErrorActionTypeSessionTimeOut = 52,
    kErrorActionTypeShowMaintenance = 53,
    kErrorActionTypeMessageInScreen = 54,
    kErrorActionTypeMessageExit = 55,
    kErrorActionTypeMessageReInitialize = 56,
    kErrorActionTypeMessageWithOKandCANCEL = 57,
    kErrorActionTypeMessageIgnore = 58,
    kErrorActionTypeMessageDR = 60
}

public class BaseError: Error {
    public var message: String = ""
    public var infoID: String = ""
    public var svcName: String = ""
    public var errorType: ErrorTypes = ErrorTypes.None
    public var actionType: ErrorDisplayTypes = ErrorDisplayTypes.kErrorActionTypeOK
    public var data: [String: Any] = [:]
}

public enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
    case delete = "DELETE"
    case put = "PUT"
}
