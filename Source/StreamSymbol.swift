//
//  StreamSymbol.swift
//  Streaming SDK
//
//  Created by Janita Alice on 08/12/20.
//

import Foundation

struct StreamSymbol: DataProvider {

    typealias ProvidedData = StreamSymbol

    var symbol: String!

    private enum CodingKeys: String, CodingKey {
        case symbol
    }

    init() {
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {symbol = try values.decode(String.self, forKey: .symbol)} catch {}
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {try container.encode(symbol, forKey: .symbol)} catch {}
    }

}


