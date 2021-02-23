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
    
    public init(socketHostUrl: String, socketMode: String, socketHostPort: Int) {
        self.socketHostUrl = socketHostUrl
        self.socketMode = socketMode
        self.socketHostPort = socketHostPort
    }
    
}
