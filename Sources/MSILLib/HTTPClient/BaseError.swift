//
//  File.swift
//  
//
//  Created by Janita Alice on 31/12/20.
//

import Foundation

enum ErrorTypes {
    case Network
    case Server
    case InvalidSession
    case Parsing
    case None
}

enum ErrorDisplayTypes: Int {
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

class BaseError: Error {
    var message: String = ""
    var infoID: String = ""
    var svcName: String = ""
    var errorType: ErrorTypes = ErrorTypes.None
    var actionType: ErrorDisplayTypes = ErrorDisplayTypes.kErrorActionTypeOK
    var data: [String: Any] = [:]
}
