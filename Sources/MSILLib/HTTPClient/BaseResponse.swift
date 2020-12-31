//
//  File.swift
//  
//
//  Created by Janita Alice on 31/12/20.
//

struct BaseResponse<T: DataProvider>: Codable {

    var response = JSONResponsePart<T>()
    private enum CodingKeys: String, CodingKey {
        case response
    }
    init() {

    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        response = try values.decode(JSONResponsePart.self, forKey: .response)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(response, forKey: .response)
    }
}


