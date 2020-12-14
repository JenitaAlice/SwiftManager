//
//  MarketDepthStreamerResponse.swift
//  Streaming SDK
//
//  Created by Janita Alice on 08/12/20.
//

import Foundation

struct MarketDepthStreamerResponse : DataProvider {
    typealias ProvidedData = MarketDepthStreamerResponse
    
    var taq : String!
    var tbq : String!
    var ltt : String!
    var sym : String!
    //var bid : [MarketDepthStreamerResponseBid]!//Array of objects of class MarketDepthStreamerResponseBid
    //var ask : [MarketDepthStreamerResponseAsk]!//Array of objects of class MarketDepthStreamerResponseAsk

    public enum CodingKeys: String, CodingKey
    {
        case taq
        case tbq
        case ltt
        case sym
        case bid
        case ask
    }

    init() {
    }

    init(from decoder:Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {taq = try values.decode(String.self, forKey: .taq)}catch{}
        do {tbq = try values.decode(String.self, forKey: .tbq)}catch{}
        do {ltt = try values.decode(String.self, forKey: .ltt)}catch{}
        do {sym = try values.decode(String.self, forKey: .sym)}catch{}
        //do {bid = try values.decode([MarketDepthStreamerResponseBid].self, forKey: .bid)}catch{}
        //do {ask = try values.decode([MarketDepthStreamerResponseAsk].self, forKey: .ask)}catch{}
    }

    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let taq = taq { do { try container.encode(taq, forKey: .taq) }catch{} }
        if let tbq = tbq { do { try container.encode(tbq, forKey: .tbq) }catch{} }
        if let ltt = ltt { do { try container.encode(ltt, forKey: .ltt) }catch{} }
        if let sym = sym { do { try container.encode(sym, forKey: .sym) }catch{} }
        //if let bid = bid { do { try container.encode(bid, forKey: .bid) }catch{} }
        //if let ask = ask { do { try container.encode(ask, forKey: .ask) }catch{} }
    }

    func getValueForKey(key : CodingKeys)-> AnyObject
    {
        switch key.rawValue {
        case CodingKeys.taq.rawValue:
            return self.taq as AnyObject
        case CodingKeys.tbq.rawValue:
            return self.tbq as AnyObject
        case CodingKeys.ltt.rawValue:
            return self.ltt as AnyObject
        case CodingKeys.sym.rawValue:
            return self.sym as AnyObject
//        case CodingKeys.bid.rawValue:
//            return self.bid as AnyObject
//        case CodingKeys.ask.rawValue:
//            return self.ask as AnyObject
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
