//
//  BinaryAsksResponse.swift
//  Binary Streaming
//
//  Created by Janita Alice on 23/12/20.
//

import Foundation

struct Asks: DataProvider {

    typealias ProvidedData = Asks

    var qty: String?
    var no: String?
    var price: String?

    private enum CodingKeys: String, CodingKey {
        case qty
        case no
        case price
    }

    init() {
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {qty = try values.decode(String.self, forKey: .qty)} catch {}
        do {no = try values.decode(String.self, forKey: .no)} catch {}
        do {price = try values.decode(String.self, forKey: .price)} catch {}
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {try container.encode(qty, forKey: .qty)} catch {}
        do {try container.encode(no, forKey: .no)} catch {}
        do {try container.encode(price, forKey: .price)} catch {}
    }

}

