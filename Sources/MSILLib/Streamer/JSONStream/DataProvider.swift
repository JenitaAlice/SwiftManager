//
//  DataProvider.swift
//  Streaming SDK
//
//  Created by Janita Alice on 08/12/20.
//

import UIKit

public protocol DataProvider: Codable {
    public associatedtype ProvidedData: DataProvider

    public func getServletGroup() -> String
    public func getServletName() -> String
    public func getServletVersion() -> String
}
  
public extension DataProvider {
    public func getServletGroup() -> String {
        return ""
    }
    public func getServletName() -> String {
        return ""
    }
    public func getServletVersion() -> String {
        return ""
    }
    
    public var asDictionary : [String:Any] {
      let mirror = Mirror(reflecting: self)
      let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?,value:Any) -> (String,Any)? in
        guard label != nil else { return nil }
        return (label!,value)
      }).compactMap{ $0 })
      return dict
    }
}

