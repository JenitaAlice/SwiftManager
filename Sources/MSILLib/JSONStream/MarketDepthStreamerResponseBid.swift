//
//  MarketDepthStreamerResponseBid.swift
//  Binary Streaming
//
//  Created by Janita Alice on 29/12/20.
//

import Foundation

struct MarketDepthStreamerResponseBid : DataProvider {
    typealias ProvidedData = MarketDepthStreamerResponseBid
    
    var no : String!
    var qt : String!
    var pr : String!

    public enum CodingKeys: String, CodingKey
    {
        case no
        case qt
        case pr
    }

    init() {
    }

    init(from decoder:Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {no = try values.decode(String.self, forKey: .no)}catch{}
        do {qt = try values.decode(String.self, forKey: .qt)}catch{}
        do {pr = try values.decode(String.self, forKey: .pr)}catch{}
    }

    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let no = no { do { try container.encode(no, forKey: .no) }catch{} }
        if let qt = qt { do { try container.encode(qt, forKey: .qt) }catch{} }
        if let pr = pr { do { try container.encode(pr, forKey: .pr) }catch{} }
    }

    func getValueForKey(key : CodingKeys)-> AnyObject
    {
        switch key.rawValue {
        case CodingKeys.no.rawValue:
            return self.no as AnyObject
        case CodingKeys.qt.rawValue:
            return self.qt as AnyObject
        case CodingKeys.pr.rawValue:
            return self.pr as AnyObject
        default:return "" as AnyObject
        }
    }
    func getServletGroup() -> String {
     return "Streamer"
    }
    func getServletName() -> String {
     return "MarketDepth"
    }
    func getServletVersion() -> String {
     return "1.0.0"
    }

}
