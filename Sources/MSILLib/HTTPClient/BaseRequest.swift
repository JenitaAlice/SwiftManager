//
//  File.swift
//  
//
//  Created by Janita Alice on 31/12/20.
//

import UIKit

struct BaseRequest<T: DataProvider>: Codable {
    var request = JSONRequestPart<T>()
    private enum CodingKeys: String, CodingKey {
        case request
    }
    init() {

    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        request = try values.decode(JSONRequestPart.self, forKey: .request)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(request, forKey: .request)
    }
}

