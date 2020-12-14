//
//  MSFStreamResponse.swift
//  Streaming SDK
//
//  Created by Janita Alice on 08/12/20.
//

import Foundation

struct MSFStreamResponse<T: DataProvider>: Codable {

    var response = JSONStreamResponsePart<T>()
    private enum CodingKeys: String, CodingKey {
        case response
    }
    init() {

    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        response = try values.decode(JSONStreamResponsePart.self, forKey: .response)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(response, forKey: .response)
    }
}

