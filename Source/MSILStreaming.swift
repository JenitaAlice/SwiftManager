//
//  MSILStreaming.swift
//  MSILStreaming
//
//  Created by Janita Alice on 09/12/20.
//

public protocol MSILStreamingDelegate: class {
    func streamingRecived<response: DataProvider>(response: response)
    func showerror(error: String?)
}

public class MSILStreaming: StreamerManagerDelegate {
    
    /**  contains value of streaming url */
    public var streamingURL: String?
    
    /**  contains value of streaming port */
    public var streamingPort: String?
    
    /** flag for binary (Binary or JSON)  */
    public var isBinary: Bool?
    
    /** Delegate for MSIL Streaming  */
    public var delegate: MSILStreamingDelegate?
    
    /** value of the socket type (TCP or TLS)  */
    public var socketType: String?
    
    /** value of session ID  */
    public var sessionid: String?
    
    /** flag for certificate pin  */
    public var isCertificatePinned: Bool?
    
    public var sType: StreamType = .Quote
    
    public init() {
    }
    
    public func createConnection() {
        if(streamingURL == nil || streamingPort == nil){
            delegate?.showerror(error: "Please enter proper streaming url and port")
        }else{
            StreamerManager.shared.createConnection(streamingURL: self.streamingURL ?? "", streamingPort: self.streamingPort ?? "")
        }
    }
    
    public func subscribeSymbols(syms: [String]) {
        StreamerManager.shared.subscribe(syms: syms, objSub: self, sType: sType)
        StreamerManager.shared.startStreamingForType(sType: .Quote)
    }
    
    public func unsubscribeSymbol(sym: String) {
        StreamerManager.shared.unSubscribe(aSym: sym, objSub: self, sType: sType)
    }
    
    public func unsubscribeAll() {
        StreamerManager.shared.unSubscribeAll()
    }
    
    public func startStreaming() {
        StreamerManager.shared.startStreamingForType(sType: sType)
    }
    
    public func stopStreaming() {
        StreamerManager.shared.stopStreamingForType(sType: sType)
    }
    
    public func closeConnection() {
        StreamerManager.shared.closeConnection()
    }

    func streamingResponseRecived<response>(response: response) where response : DataProvider {
        delegate?.streamingRecived(response: response)
    }
    
    
}
