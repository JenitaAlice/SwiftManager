//
//  HttpClientConfig.swift
//  Binary Streaming
//
//  Created by Janita Alice on 28/12/20.
//

import Foundation

struct HttpClientConfig {
    
    var encryptionEnabled: Bool
    var encryptionKey: String
    var requestTimeout: Int  = 30
    var connectionTimeout: Int  = 5
    
}
