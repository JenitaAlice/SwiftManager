//
//  File.swift
//  
//
//  Created by Janita Alice on 31/12/20.
//

import Foundation

class BaseValidator: NSObject {

    static func isValidResponse(infoID: String) -> Bool {

        // Check for Info ID and validate
        if infoID == "0"{
            return true
        }
        return false
    }

    static func getInfoID(forDictionary: NSDictionary) -> String {

        var dictData: NSDictionary
        dictData  = forDictionary["response"] as! NSDictionary
        let infoID: String = dictData["infoID"] as! String
        return infoID
    }

    static func getInfoMessage(forDictionary: NSDictionary) -> String {
        var dictData: NSDictionary
        dictData  = forDictionary["response"] as! NSDictionary
        let infoMsg: String = dictData["infoMsg"] as! String
        return infoMsg
    }

    static func getDataPartFromResponse(forDictionary: NSDictionary) -> NSDictionary {

        var dictData: NSDictionary
        dictData  = forDictionary["response"] as! NSDictionary
        let dataPart = dictData["data"] as! NSDictionary
        return dataPart
    }
}
