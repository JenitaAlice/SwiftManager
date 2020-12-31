//
//  File.swift
//  
//
//  Created by Janita Alice on 31/12/20.
//

import Foundation
 
protocol ValidatorWorkerProtocol {
    func getError(error: BaseError) -> BaseError
}

class ValidatorWorker: ValidatorWorkerProtocol {
    func getError(error: BaseError) -> BaseError {
        if error.infoID.count > 0 {
            error.actionType = InfoConfigManager.shared.getAction(infoID: error.infoID)
            if error.message.count == 0 {
                if let mssg = InfoConfigManager.shared.getMessage(infoID: error.infoID) {
                    error.message = mssg
                }
            }
            error.errorType = .Server
        }
        return error

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
