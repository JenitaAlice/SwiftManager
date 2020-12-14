//
//  StreamRequestQuote.swift
//  Streaming SDK
//
//  Created by Janita Alice on 08/12/20.
//

import Foundation

struct StreamRequestQuote: DataProvider {

    typealias ProvidedData = StreamRequestQuote

    var symbols: [StreamSymbol]!

    private enum CodingKeys: String, CodingKey {
        case symbols
    }

    init() {
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {symbols = try values.decode([StreamSymbol].self, forKey: .symbols)} catch {}
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {try container.encode(symbols, forKey: .symbols)} catch {}
    }

}


