//
//  File.swift
//  
//
//  Created by Janita Alice on 14/12/20.
//

#if !os(macOS)

import UIKit

public protocol DataProvider: Codable {
    associatedtype ProvidedData: DataProvider

    func getServletGroup() -> String
    func getServletName() -> String
    func getServletVersion() -> String
}

extension DataProvider {
    func getServletGroup() -> String {
        return ""
    }
    func getServletName() -> String {
        return ""
    }
    func getServletVersion() -> String {
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

#endif
