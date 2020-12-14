//
//  JSONStreamRequestPart.swift
//  Streaming SDK
//
//  Created by Janita Alice on 08/12/20.
//

#if !os(macOS)

import Foundation
import UIKit

struct JSONStreamRequestPart<T: DataProvider>: Codable {
    var streaming_type: String?
    var request_type: String?
    var response_format: String?
    var appID: String?
    var data: T.ProvidedData?

    private enum CodingKeys: String, CodingKey {
        case streaming_type
        case request_type
        case response_format
        case data
        case formFactor
        case appID
    }
    init() {

    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        streaming_type = try values.decode(String.self, forKey: .streaming_type)
        request_type = try values.decode(String.self, forKey: .request_type)
        response_format = try values.decode(String.self, forKey: .response_format)
        appID = try values.decode(String.self, forKey: .appID)
        data = try values.decode(T.ProvidedData.self, forKey: .data)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(streaming_type, forKey: .streaming_type)
        try container.encode(request_type, forKey: .request_type)
        try container.encode(response_format, forKey: .response_format)
        try container.encode(appID, forKey: .appID)
        try container.encode(data, forKey: .data)
    }
}

struct JSONStreamEchoPart<T: DataProvider> : Codable {
    var appID : String?
    
    private enum CodingKeys: String, CodingKey {
        case appID
    }
    
    init(){}
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        appID = try values.decode(String.self, forKey: .appID)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(appID, forKey: .appID)
    }
    
}

#endif
