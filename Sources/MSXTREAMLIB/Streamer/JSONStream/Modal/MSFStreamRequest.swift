//
//  MSFStreamRequest.swift
//  Streaming SDK
//
//  Created by Janita Alice on 08/12/20.
//

import Foundation

struct MSFStreamRequest<T: DataProvider>: Codable {
    
    var request = JSONStreamRequestPart<T>()
    var echo = JSONStreamEchoPart<T>()
    
    private enum CodingKeys: String, CodingKey {
        case request
        case echo
    }
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        request = try values.decode(JSONStreamRequestPart.self, forKey: .request)
        echo = try values.decode(JSONStreamEchoPart.self, forKey: .echo)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(request, forKey: .request)
        try container.encode(echo, forKey: .echo)
    }
}


