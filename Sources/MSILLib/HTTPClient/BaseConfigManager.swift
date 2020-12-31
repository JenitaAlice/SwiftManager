//
//  File.swift
//  
//
//  Created by Janita Alice on 31/12/20.
//

import Foundation

class BaseConfigManager: NSObject, NSCopying, NSCoding {

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = BaseConfigManager()
        return copy
    }

   enum BaseConfigKey {
        static let kApp = "app"
        static let kLabel = "label"
        static let kMessage = "message"
        static let kFunctionalAccess = "functionalAccess"
        static let kDisclaimer = "disclaimer"
        static let kMenu = "menu"
        static let kVersionDetail = "versionDetail"
        static let kRSS = "rss"
        static let kPromotion = "promoContent"
        static let kVersion = "version"
        static let kConfig = "config"
        static let streamingURLs = "streamingURLs"
        static let streamingRate = "streamingRate"
    }

     var version: Int! = 0
     var arrayConfigData: NSMutableArray?
    var dicFormatedData: NSMutableDictionary?
//    static let shared = BaseConfigManager()

    override init() {
        self.arrayConfigData = NSMutableArray()
        self.dicFormatedData = NSMutableDictionary()
        self.version = 0
    }

    func setConfig(config: BaseConfigManager?) {
        if let config = config {
            self.dicFormatedData = config.dicFormatedData
            self.arrayConfigData = config.arrayConfigData
            self.version = config.version
        }
    }
//     func encode(with aCoder: NSCoder) {
    func encode(with aCoder: NSCoder) {
        //print("current version in \(self.classForCoder)\(String(describing: self.version))")
        aCoder.encode(self.version, forKey: BaseConfigKey.kVersion)
        aCoder.encode(self.arrayConfigData, forKey: "arrayConfigData")
        aCoder.encode(self.dicFormatedData, forKey: "dicFormatedData")

    }

    required init?(coder aDecoder: NSCoder) {
        self.version = aDecoder.decodeObject(forKey: BaseConfigKey.kVersion) as? Int
        self.arrayConfigData = aDecoder.decodeObject(forKey: "arrayConfigData") as? NSMutableArray
        self.dicFormatedData = aDecoder.decodeObject(forKey: "dicFormatedData") as? NSMutableDictionary
    }

//    static let shared = BaseConfigManager()

    /*
     #pragma mark Local - Instance Methods
     - (void)update:(NSMutableArray*)aryUpdate
     {
         NSArray * originalKeyArray = [self.arrayConfigData valueForKeyPath:@"key"];
         NSArray * updateKeyArray = [aryUpdate valueForKeyPath:@"key"];
         
         NSInteger idx = 0;
         NSString *key;
         
         NSMutableArray *tempAry = [[NSMutableArray alloc] init];
         for (NSInteger i=0; i<[updateKeyArray count]; i++) {
             key = [updateKeyArray objectAtIndex:i];
             idx = [originalKeyArray indexOfObject:key];
             if (idx != NSNotFound) {
                 [self.arrayConfigData replaceObjectAtIndex:idx withObject:[aryUpdate objectAtIndex:i]];
             }else {
                 [tempAry addObject:[aryUpdate objectAtIndex:i]];
             }
         }
         [self.arrayConfigData addObjectsFromArray:tempAry];
     }

     */

    func update(aryUpdate: NSArray) {
//        let originalKeyArray : NSArray = arrayConfigData?.value(forKeyPath: "key") as! NSArray
//        let updateKeyArray : NSArray = aryUpdate.value(forKeyPath: "key") as! NSArray
//
//        let idx : Int = 0
//        var key : String!
//
//        var tempAry : NSMutableArray = NSMutableArray()
//
//        for i in updateKeyArray {
//            key = updateKeyArray[]
//        }
//
//
//
    }

    /*
     
     - (void)handleData:(NSDictionary *)data
     {
         if (data) {
             self.version = [data objectForKey:kVersion];
             if ([self.arrayConfigData count] > 0) {
                 if ([data objectForKey:kConfig]) {
                     [self update:[data objectForKey:kConfig]];
                 }
             }else {
                 [self.arrayConfigData setArray:[data objectForKey:kConfig]];
             }
             [self.dicFormatedData setDictionary:[NSDictionary dictionaryWithObjects:[self.arrayConfigData valueForKey:@"value"] forKeys:[self.arrayConfigData valueForKey:@"key"]]];
         }
     }

     */

    func isTimeStampChanged(config: NSDictionary) -> Bool {

        let tstamp = config.object(forKey: BaseConfigKey.kApp) as! Int
        return tstamp != (version as AnyObject).integerValue
    }

    func handleData(data: NSDictionary) {
        if data.count > 0 {

//            // Version assign only for Any type
//            if let configVersion = data.object(forKey: BaseConfigKey.kVersion) as? Int {
//                self.version = configVersion
//            }
//
////            self.version = data[BaseConfigKey.kVersion] as? NSString
//            if self.arrayConfigData!.count > 0 {
//                if let resultData = data.object(forKey: BaseConfigKey.kConfig) as? NSArray {
//                    update(aryUpdate: resultData)
//                }
//            } else {
//                if let arraydata = data.object(forKey: BaseConfigKey.kConfig) {
//                    self.arrayConfigData = NSMutableArray.init(array: arraydata as! NSArray)
//                }
//            }
//            [self.dicFormatedData setDictionary:[NSDictionary dictionaryWithObjects:[self.arrayConfigData valueForKey:@"value"] forKeys:[self.arrayConfigData valueForKey:@"key"]]];

            if let arraydata = data.object(forKey: BaseConfigKey.kConfig) {
                self.arrayConfigData = NSMutableArray.init(array: arraydata as! NSArray)
            }
            if let value = arrayConfigData?.value(forKey: "value"), let key = arrayConfigData?.value(forKey: "key") {
                let configdata = NSDictionary.init(objects: value as! [AnyObject], forKeys: key as! [NSCopying])
                self.dicFormatedData?.setDictionary(configdata as! [AnyHashable: Any])

                //.addEntries(from: configdata as! [AnyHashable : Any])
            }

//            let configdata = NSDictionary.init(objects: self.arrayConfigData?.value(forKey: "key") as! [Any], forKeys: self.arrayConfigData?.value(forKey: "value"))

//            self.dicFormatedData?.addEntries(from:configdata  as! [String : Any])
            //setDictionary(data as! [AnyHashable : Any])
        }
    }

    // - (id)getValueForKey:(NSString*)key

    func getValueForKey(key: String) -> Any? {
        if let value = self.dicFormatedData?.object(forKey: key) {
            return value
        }
        return nil
    }

}

