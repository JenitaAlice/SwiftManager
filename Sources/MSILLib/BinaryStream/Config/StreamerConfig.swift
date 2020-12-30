//
//  StreamerConfig.swift
//  Binary Streaming
//
//  Created by Janita Alice on 28/12/20.
//

import Foundation

public struct StreamerConfig {
    
    public var socketHostUrl: String!
    public var socketMode: String!
    public var socketHostPort: Int!
    public var binaryStream: Bool!
    
    public init(socketHostUrl: String, socketMode: String, socketHostPort: Int, binaryStream: Bool) {
        self.socketHostUrl = socketHostUrl
        self.socketMode = socketMode
        self.socketHostPort = socketHostPort
        self.binaryStream = binaryStream
    }
    
}
