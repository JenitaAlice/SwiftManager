//
//  LibConstant.swift
//  Binary Streaming
//
//  Created by Janita Alice on 28/12/20.
//

import Foundation

public class SocketMode {
    public static var TLS: String = "TLS"
    public static var TCP: String = "TCP"
}

public class StreamRequestType {
    public static var subscribe: String = "subscribe"
    public static var unsubscribe: String = "unsubscribe"
}

public class StreamLevel {
    public static var quote: StreamType = .Quote
    public static var quote2: StreamType = .Quote2
}
