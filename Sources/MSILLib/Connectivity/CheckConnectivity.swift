//
//  CheckConnectivity.swift
//  Binary Streaming
//
//  Created by Janita Alice on 28/12/20.
//

import Foundation
import CoreTelephony
import SystemConfiguration

public class Connectivity {
    
    public class func getConnectionType() -> String {
        guard let reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, "www.google.com") else {
            return "NO INTERNET"
        }
        
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        
        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)
        
        if isReachable {
            
            if isWWAN {
                
                let networkInfo = CTTelephonyNetworkInfo()
                
                let currCarrierType: String?
                
                if #available(iOS 12.0, *) {
                    
                    let carrierType = networkInfo.serviceCurrentRadioAccessTechnology
                    
                    guard let carrierTypeName = carrierType?.first?.value else {
                        return "UNKNOWN"
                    }
                    
                    currCarrierType = carrierTypeName
                    
                } else {
                    
                    guard let carrierType = networkInfo.currentRadioAccessTechnology else {
                        return "UNKNOWN"
                    }
                    currCarrierType = carrierType
                    
                }
                
                switch currCarrierType{
                    case CTRadioAccessTechnologyGPRS:
                        return "2G" + " (GPRS)"

                    case CTRadioAccessTechnologyEdge:
                        return "2G" + " (Edge)"

                    case CTRadioAccessTechnologyCDMA1x:
                        return "2G" + " (CDMA1x)"

                    case CTRadioAccessTechnologyWCDMA:
                        return "3G" + " (WCDMA)"

                    case CTRadioAccessTechnologyHSDPA:
                        return "3G" + " (HSDPA)"

                    case CTRadioAccessTechnologyHSUPA:
                        return "3G" + " (HSUPA)"

                    case CTRadioAccessTechnologyCDMAEVDORev0:
                        return "3G" + " (CDMAEVDORev0)"

                    case CTRadioAccessTechnologyCDMAEVDORevA:
                        return "3G" + " (CDMAEVDORevA)"

                    case CTRadioAccessTechnologyCDMAEVDORevB:
                        return "3G" + " (CDMAEVDORevB)"

                    case CTRadioAccessTechnologyeHRPD:
                        return "3G" + " (eHRPD)"

                    case CTRadioAccessTechnologyLTE:
                        return "4G" + " (LTE)"

                    default:
                        break;
                    }
                
                return "newer type!"
                
            } else {
                
                return "WIFI"
                
            }
            
        } else {
            
            return "NO INTERNET"
            
        }
        
    }
    
}
