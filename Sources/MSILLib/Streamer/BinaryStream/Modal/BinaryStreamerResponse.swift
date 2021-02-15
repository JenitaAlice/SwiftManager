//
//  BinaryStreamerResponse.swift
//  Binary Streaming
//
//  Created by Janita Alice on 22/12/20.
//

import Foundation

public struct BinaryStreamerResponse : DataProvider {
    
    public typealias ProvidedData = BinaryStreamerResponse
    
    public var atp : String?
    public var chng : String?
    public var chngPer : String?
    public var close : String?
    public var high : String?
    public var lcl : String?
    public var low : String?
    public var ltp : String?
    public var ltq : String?
    public var ltt : String?
    public var open : String?
    public var symbol : String?
    public var ttv : String?
    public var ucl : String?
    public var vol : String?
    public var yHigh : String?
    public var yLow : String?
    public var OI: String?
    public var OIChngPer: String?
    public var precision: String?

    public enum CodingKeys: String, CodingKey
    {
        case atp
        case chng
        case chngPer
        case close
        case high
        case lcl
        case low
        case ltp
        case ltq
        case ltt
        case open
        case symbol
        case ttv
        case ucl
        case vol
        case yHigh
        case yLow
        case OI
        case OIChngPer
        case precision
    }

    public init() {
    }

    public init(from decoder:Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {atp = try values.decode(String.self, forKey: .atp)}catch{}
        do {chng = try values.decode(String.self, forKey: .chng)}catch{}
        do {chngPer = try values.decode(String.self, forKey: .chngPer)}catch{}
        do {close = try values.decode(String.self, forKey: .close)}catch{}
        do {high = try values.decode(String.self, forKey: .high)}catch{}
        do {lcl = try values.decode(String.self, forKey: .lcl)}catch{}
        do {low = try values.decode(String.self, forKey: .low)}catch{}
        do {ltp = try values.decode(String.self, forKey: .ltp)}catch{}
        do {ltq = try values.decode(String.self, forKey: .ltq)}catch{}
        do {ltt = try values.decode(String.self, forKey: .ltt)}catch{}
        do {open = try values.decode(String.self, forKey: .open)}catch{}
        do {symbol = try values.decode(String.self, forKey: .symbol)}catch{}
        do {ttv = try values.decode(String.self, forKey: .ttv)}catch{}
        do {ucl = try values.decode(String.self, forKey: .ucl)}catch{}
        do {vol = try values.decode(String.self, forKey: .vol)}catch{}
        do {yHigh = try values.decode(String.self, forKey: .yHigh)}catch{}
        do {yLow = try values.decode(String.self, forKey: .yLow)}catch{}
        do {OI = try values.decode(String.self, forKey: .OI)}catch{}
        do {OIChngPer = try values.decode(String.self, forKey: .OIChngPer)}catch{}
        do {precision = try values.decode(String.self, forKey: .precision)}catch{}
    }

    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let atp = atp { do { try container.encode(atp, forKey: .atp) }catch{} }
        if let chng = chng { do { try container.encode(chng, forKey: .chng) }catch{} }
        if let chngPer = chngPer { do { try container.encode(chngPer, forKey: .chngPer) }catch{} }
        if let close = close { do { try container.encode(close, forKey: .close) }catch{} }
        if let high = high { do { try container.encode(high, forKey: .high) }catch{} }
        if let lcl = lcl { do { try container.encode(lcl, forKey: .lcl) }catch{} }
        if let low = low { do { try container.encode(low, forKey: .low) }catch{} }
        if let ltp = ltp { do { try container.encode(ltp, forKey: .ltp) }catch{} }
        if let ltq = ltq { do { try container.encode(ltq, forKey: .ltq) }catch{} }
        if let ltt = ltt { do { try container.encode(ltt, forKey: .ltt) }catch{} }
        if let open = open { do { try container.encode(open, forKey: .open) }catch{} }
        if let symbol = symbol { do { try container.encode(symbol, forKey: .symbol) }catch{} }
        if let ttv = ttv { do { try container.encode(ttv, forKey: .ttv) }catch{} }
        if let ucl = ucl { do { try container.encode(ucl, forKey: .ucl) }catch{} }
        if let vol = vol { do { try container.encode(vol, forKey: .vol) }catch{} }
        if let yHigh = yHigh { do { try container.encode(yHigh, forKey: .yHigh) }catch{} }
        if let yLow = yLow { do { try container.encode(yLow, forKey: .yLow) }catch{} }
        if let OI = OI { do { try container.encode(OI, forKey: .OI) }catch{} }
        if let OIChngPer = OIChngPer { do { try container.encode(OIChngPer, forKey: .OIChngPer) }catch{} }
        if let precision = precision { do { try container.encode(precision, forKey: .precision) }catch{} }
    }

    public func getValueForKey(key : CodingKeys)-> AnyObject
    {
        switch key.rawValue {
        case CodingKeys.atp.rawValue:
            return self.atp as AnyObject
        case CodingKeys.chng.rawValue:
            return self.chng as AnyObject
        case CodingKeys.chngPer.rawValue:
            return self.chngPer as AnyObject
        case CodingKeys.close.rawValue:
            return self.close as AnyObject
        case CodingKeys.high.rawValue:
            return self.high as AnyObject
        case CodingKeys.lcl.rawValue:
            return self.lcl as AnyObject
        case CodingKeys.low.rawValue:
            return self.low as AnyObject
        case CodingKeys.ltp.rawValue:
            return self.ltp as AnyObject
        case CodingKeys.ltq.rawValue:
            return self.ltq as AnyObject
        case CodingKeys.ltt.rawValue:
            return self.ltt as AnyObject
        case CodingKeys.vol.rawValue:
            return self.vol as AnyObject
        case CodingKeys.open.rawValue:
            return self.open as AnyObject
        case CodingKeys.ttv.rawValue:
            return self.ttv as AnyObject
        case CodingKeys.symbol.rawValue:
            return self.symbol as AnyObject
        case CodingKeys.ucl.rawValue:
            return self.ucl as AnyObject
        case CodingKeys.vol.rawValue:
            return self.vol as AnyObject
        case CodingKeys.yHigh.rawValue:
            return self.yHigh as AnyObject
        case CodingKeys.yLow.rawValue:
            return self.yLow as AnyObject
        case CodingKeys.OI.rawValue:
            return self.OI as AnyObject
        case CodingKeys.OIChngPer.rawValue:
            return self.OIChngPer as AnyObject
        case CodingKeys.precision.rawValue:
            return self.precision as AnyObject
        default:return "" as AnyObject
        }
    }
    public func getServletGroup() -> String {
     return "Streamer"
    }
    public func getServletName() -> String {
     return "Quote"
    }
    public func getServletVersion() -> String {
     return "1.0.0"
    }

}
