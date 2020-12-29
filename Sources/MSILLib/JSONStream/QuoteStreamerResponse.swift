//
//  QuoteStreamerResponse.swift
//  Streaming SDK
//
//  Created by Janita Alice on 08/12/20.
//

import Foundation

struct QuoteStreamerResponse : DataProvider {
    typealias ProvidedData = QuoteStreamerResponse
    
    var ch : String!
    var ltq : String!
    var c : String!
    var yL : String!
    var aPr : String!
    var aSz : String!
    var sym : String!
    var oI : String!
    var avP : String!
    var h : String!
    var vol : String!
    var ttq : String!
    var ttv : String!
    var yH : String!
    var ltt : String!
    var bPr : String!
    var bSz : String!
    var l : String!
    var chp : String!
    var ltp : String!
    var tBQ : String!
    var tSQ : String!
    var o : String!
    var ind : String!

    public enum CodingKeys: String, CodingKey
    {
        case ch
        case ltq
        case c
        case yL
        case aPr
        case aSz
        case sym
        case oI
        case avP
        case h
        case vol
        case ttq
        case ttv
        case yH
        case ltt
        case bPr
        case bSz
        case l
        case chp
        case ltp
        case tBQ
        case tSQ
        case o
        case ind
    }

    init() {
    }

    init(from decoder:Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {ch = try values.decode(String.self, forKey: .ch)}catch{}
        do {ltq = try values.decode(String.self, forKey: .ltq)}catch{}
        do {c = try values.decode(String.self, forKey: .c)}catch{}
        do {yL = try values.decode(String.self, forKey: .yL)}catch{}
        do {aPr = try values.decode(String.self, forKey: .aPr)}catch{}
        do {aSz = try values.decode(String.self, forKey: .aSz)}catch{}
        do {sym = try values.decode(String.self, forKey: .sym)}catch{}
        do {oI = try values.decode(String.self, forKey: .oI)}catch{}
        do {avP = try values.decode(String.self, forKey: .avP)}catch{}
        do {h = try values.decode(String.self, forKey: .h)}catch{}
        do {vol = try values.decode(String.self, forKey: .vol)}catch{}
        do {ttq = try values.decode(String.self, forKey: .ttq)}catch{}
        do {ttv = try values.decode(String.self, forKey: .ttv)}catch{}
        do {yH = try values.decode(String.self, forKey: .yH)}catch{}
        do {ltt = try values.decode(String.self, forKey: .ltt)}catch{}
        do {bPr = try values.decode(String.self, forKey: .bPr)}catch{}
        do {bSz = try values.decode(String.self, forKey: .bSz)}catch{}
        do {l = try values.decode(String.self, forKey: .l)}catch{}
        do {chp = try values.decode(String.self, forKey: .chp)}catch{}
        do {ltp = try values.decode(String.self, forKey: .ltp)}catch{}
        do {tBQ = try values.decode(String.self, forKey: .tBQ)}catch{}
        do {tSQ = try values.decode(String.self, forKey: .tSQ)}catch{}
        do {o = try values.decode(String.self, forKey: .o)}catch{}
        do {ind = try values.decode(String.self, forKey: .ind)}catch{}
    }

    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let ch = ch { do { try container.encode(ch, forKey: .ch) }catch{} }
        if let ltq = ltq { do { try container.encode(ltq, forKey: .ltq) }catch{} }
        if let c = c { do { try container.encode(c, forKey: .c) }catch{} }
        if let yL = yL { do { try container.encode(yL, forKey: .yL) }catch{} }
        if let aPr = aPr { do { try container.encode(aPr, forKey: .aPr) }catch{} }
        if let aSz = aSz { do { try container.encode(aSz, forKey: .aSz) }catch{} }
        if let sym = sym { do { try container.encode(sym, forKey: .sym) }catch{} }
        if let oI = oI { do { try container.encode(oI, forKey: .oI) }catch{} }
        if let avP = avP { do { try container.encode(avP, forKey: .avP) }catch{} }
        if let h = h { do { try container.encode(h, forKey: .h) }catch{} }
        if let vol = vol { do { try container.encode(vol, forKey: .vol) }catch{} }
        if let ttq = ttq { do { try container.encode(ttq, forKey: .ttq) }catch{} }
        if let ttv = ttv { do { try container.encode(ttv, forKey: .ttv) }catch{} }
        if let yH = yH { do { try container.encode(yH, forKey: .yH) }catch{} }
        if let ltt = ltt { do { try container.encode(ltt, forKey: .ltt) }catch{} }
        if let bPr = bPr { do { try container.encode(bPr, forKey: .bPr) }catch{} }
        if let bSz = bSz { do { try container.encode(bSz, forKey: .bSz) }catch{} }
        if let l = l { do { try container.encode(l, forKey: .l) }catch{} }
        if let chp = chp { do { try container.encode(chp, forKey: .chp) }catch{} }
        if let ltp = ltp { do { try container.encode(ltp, forKey: .ltp) }catch{} }
        if let tBQ = tBQ { do { try container.encode(tBQ, forKey: .tBQ) }catch{} }
        if let tSQ = tSQ { do { try container.encode(tSQ, forKey: .tSQ) }catch{} }
        if let o = o { do { try container.encode(o, forKey: .o) }catch{} }
        if let ind = ind { do { try container.encode(ind, forKey: .ind) }catch{} }
    }

    func getValueForKey(key : CodingKeys)-> AnyObject
    {
        switch key.rawValue {
        case CodingKeys.ch.rawValue:
            return self.ch as AnyObject
        case CodingKeys.ltq.rawValue:
            return self.ltq as AnyObject
        case CodingKeys.c.rawValue:
            return self.c as AnyObject
        case CodingKeys.yL.rawValue:
            return self.yL as AnyObject
        case CodingKeys.aPr.rawValue:
            return self.aPr as AnyObject
        case CodingKeys.aSz.rawValue:
            return self.aSz as AnyObject
        case CodingKeys.sym.rawValue:
            return self.sym as AnyObject
        case CodingKeys.oI.rawValue:
            return self.oI as AnyObject
        case CodingKeys.avP.rawValue:
            return self.avP as AnyObject
        case CodingKeys.h.rawValue:
            return self.h as AnyObject
        case CodingKeys.vol.rawValue:
            return self.vol as AnyObject
        case CodingKeys.ttq.rawValue:
            return self.ttq as AnyObject
        case CodingKeys.ttv.rawValue:
            return self.ttv as AnyObject
        case CodingKeys.yH.rawValue:
            return self.yH as AnyObject
        case CodingKeys.ltt.rawValue:
            return self.ltt as AnyObject
        case CodingKeys.bPr.rawValue:
            return self.bPr as AnyObject
        case CodingKeys.bSz.rawValue:
            return self.bSz as AnyObject
        case CodingKeys.l.rawValue:
            return self.l as AnyObject
        case CodingKeys.chp.rawValue:
            return self.chp as AnyObject
        case CodingKeys.ltp.rawValue:
            return self.ltp as AnyObject
        case CodingKeys.tBQ.rawValue:
            return self.tBQ as AnyObject
        case CodingKeys.tSQ.rawValue:
            return self.tSQ as AnyObject
        case CodingKeys.o.rawValue:
            return self.o as AnyObject
        case CodingKeys.ind.rawValue:
            return self.ind as AnyObject
        default:return "" as AnyObject
        }
    }
    func getServletGroup() -> String {
     return "Streamer"
    }
    func getServletName() -> String {
     return "Quote"
    }
    func getServletVersion() -> String {
     return "1.0.0"
    }

}


