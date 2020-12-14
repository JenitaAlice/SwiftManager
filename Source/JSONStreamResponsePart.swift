//
//  JSONStreamResponsePart.swift
//  Streaming SDK
//
//  Created by Janita Alice on 08/12/20.
//

import Foundation

struct JSONStreamResponsePart<T: DataProvider>: Codable {
    var streaming_type: String?
    var data: T.ProvidedData?

    private enum CodingKeys: String, CodingKey {
        case streaming_type
        case data
    }
    init() {

    }
    init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            do {streaming_type = try values.decode(String.self, forKey: .streaming_type)} catch {}
            do {data = try values.decode(T.ProvidedData.self, forKey: .data)} catch {}
        } catch {}
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {try container.encode(streaming_type, forKey: .streaming_type)} catch {}
        do {try container.encode(data, forKey: .data)} catch {}
    }
}
