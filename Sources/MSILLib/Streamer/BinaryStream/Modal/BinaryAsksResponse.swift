//
//  BinaryAsksResponse.swift
//  Binary Streaming
//
//  Created by Janita Alice on 23/12/20.
//

import Foundation

public struct Asks: DataProvider {

    public typealias ProvidedData = Asks

    public var qty: String?
    public var no: String?
    public var price: String?

    public enum CodingKeys: String, CodingKey {
        case qty
        case no
        case price
    }

    public init() {
    }

    public init(from decoder: Decoder) throws {
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

