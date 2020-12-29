//
//  StreamerConfig.swift
//  Binary Streaming
//
//  Created by Janita Alice on 28/12/20.
//

import Foundation

public struct StreamerConfig {
    
    var socketHostUrl: String!
    var socketMode: String!
    var socketHostPort: Int!
    var binaryStream: Bool!
    let socketTimeout: Int64 = Int64((Date().timeIntervalSince1970 * 2000.0).rounded())
    
}
