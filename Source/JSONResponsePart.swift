//
//  JSONResponsePart.swift
//  Streaming SDK
//
//  Created by Janita Alice on 08/12/20.
//

import Foundation

struct JSONResponsePart<T: DataProvider>: Codable {
    var infoID: String?
    var infoMsg: String?
    var msgID: String?
    var serverTime: String?
    var data: T.ProvidedData?
//    var echo:String?

    private enum CodingKeys: String, CodingKey {
        case infoID
        case infoMsg
        case msgID
        case serverTime
        case data
//        case echo
    }
    init() {

    }
    init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            do {infoID = try values.decode(String.self, forKey: .infoID)} catch {}
            do {infoMsg = try values.decode(String.self, forKey: .infoMsg)} catch {}
            do {msgID = try values.decode(String.self, forKey: .msgID)} catch {}
            do {serverTime = try values.decode(String.self, forKey: .serverTime)} catch {}
            do {data = try values.decode(T.ProvidedData.self, forKey: .data)} catch {}
//            do {echo = try values.decode(String.self, forKey: .echo)}catch{}
        } catch {}
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {try container.encode(infoID, forKey: .infoID)} catch {}
        do {try container.encode(infoMsg, forKey: .infoMsg)} catch {}
        do {try container.encode(msgID, forKey: .msgID)} catch {}
        do {try container.encode(serverTime, forKey: .serverTime)} catch {}
        do {try container.encode(data, forKey: .data)} catch {}
//         do {try container.encode(echo, forKey: .echo)}catch{}
    }
}

