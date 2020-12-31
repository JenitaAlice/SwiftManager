//
//  File.swift
//  
//
//  Created by Janita Alice on 31/12/20.
//

import UIKit

struct JSONRequestPart<T: DataProvider>: Codable {
    var appID: String?
    var data: T.ProvidedData?
    var response_format: String?
    var formFactor: String?
//    var echo : String?
//    var userName : String?
//    var accID : String?
    private enum CodingKeys: String, CodingKey {
        case appID
        case data
        case response_format
        case formFactor
//        case echo
//        case userName
//        case accID
    }
    init() {

    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        appID = try values.decode(String.self, forKey: .appID)
        data = try values.decode(T.ProvidedData.self, forKey: .data)
        response_format = try values.decode(String.self, forKey: .response_format)
        formFactor = try values.decode(String.self, forKey: .formFactor)
//        echo = try values.decode(String.self, forKey: .echo)
//        userName = try values.decode(String.self, forKey: .userName)
//        accID = try values.decode(String.self, forKey: .accID)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(appID, forKey: .appID)
        try container.encode(data, forKey: .data)
        try container.encode(response_format, forKey: .response_format)
        try container.encode(formFactor, forKey: .formFactor)
//        try container.encode(echo, forKey: .echo)
//        try container.encode(userName, forKey: .userName)
//        try container.encode(accID, forKey: .accID)
    }
}

