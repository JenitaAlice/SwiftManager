//
//  BinaryQuoteStreamerResponse.swift
//  Binary Streaming
//
//  Created by Janita Alice on 23/12/20.
//

import Foundation

public struct BinaryQuoteStreamerResponse: DataProvider {

    public typealias ProvidedData = BinaryQuoteStreamerResponse

    public var symbol: String?
    public var totBuyQty: String?
    public var totSellQty: String?
    public var bid: [Asks]?
    public var ask: [Asks]?

    public enum CodingKeys: String, CodingKey {
        case symbol
        case totBuyQty
        case totSellQty
        case bid
        case ask
    }

    public init() {
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {symbol = try values.decode(String.self, forKey: .symbol)} catch {}
        do {totBuyQty = try values.decode(String.self, forKey: .totBuyQty)} catch {}
        do {totSellQty = try values.decode(String.self, forKey: .totSellQty)} catch {}
        do {bid = try values.decode([Asks].self, forKey: .bid)} catch {}
        do {ask = try values.decode([Asks].self, forKey: .ask)} catch {}
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {try container.encode(symbol, forKey: .symbol)} catch {}
        do {try container.encode(totBuyQty, forKey: .totBuyQty)} catch {}
        do {try container.encode(totSellQty, forKey: .totSellQty)} catch {}
        do {try container.encode(bid, forKey: .bid)} catch {}
        do {try container.encode(ask, forKey: .ask)} catch {}
    }

}

