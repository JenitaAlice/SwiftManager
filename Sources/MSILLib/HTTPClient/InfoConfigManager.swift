//
//  File.swift
//  
//
//  Created by Janita Alice on 31/12/20.
//

import Foundation

class InfoConfigManager : BaseConfigManager {
    
    //    private override init() {
    //        super.init()
    //    }
    //
    //    required init?(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    static let shared = InfoConfigManager()
    
    var infoConfig : InfoConfigManager?
    //    func isTimeStampChanged(config : NSDictionary) -> Bool {
    //
    //        let tstamp = config.object(forKey: BaseConfigKey.kMessage) as! Int
    //        return tstamp != version?.integerValue
    //    }
    
    func setConfig(config : InfoConfigManager?) {

        if let config = config {
            self.dicFormatedData = config.dicFormatedData
            self.arrayConfigData = config.arrayConfigData
            self.version = config.version
        }

    }

    override func handleData(data: NSDictionary) {
        super.handleData(data: data)
//        print("InfoConfigManager \(self.version!)")
        
    }

    func getError(infoID: String?) -> BaseError {

        let err = BaseError()
        if let infoID = infoID {
            err.actionType = getAction(infoID: infoID)//errorDisplayTypes(rawValue: getAction(infoID: infoID))!
            err.message = getMessage(infoID: infoID)!
            err.infoID = infoID
            err.errorType = ErrorTypes.Server
        }
        return err
    }

    func getAction(infoID: String) -> ErrorDisplayTypes {
        if let dictInfoID = getValueForKey(key: infoID) as? NSDictionary {
            
       //   return dictInfoID.object(forKey: "action") as? ErrorDisplayTypes ?? ErrorDisplayTypes.kErrorActionTypeNone
            //This return is replaced to fix dynamic error message display
            if let strAction = dictInfoID.object(forKey: "action") as? String {
                if let action = Int(strAction) {
                    if let errorAction = ErrorDisplayTypes.init(rawValue: action) {
                        return errorAction
                    }
                }
            }
        }
        return ErrorDisplayTypes.kErrorActionTypeNone
    }

    func getMessage(infoID: String) -> String? {
        if let dictInfoID = getValueForKey(key: infoID) as? NSDictionary {
            return (dictInfoID.object(forKey: "message") as? String)!
        }
        return ""
    }

}

