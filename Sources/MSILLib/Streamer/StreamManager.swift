//
//  StreamManager.swift
//  Streaming SDK
//
//  Created by Janita Alice on 08/12/20.
//

import UIKit

public protocol StreamerManagerDelegate: class {
    func streamingResponseRecived<response: DataProvider>(response: response)
}

public enum StreamType: String {
    case Quote = "quote"
    case Quote2 = "quote2"
}

public class StreamerManager: NSObject, SocketHelperDelegate, BinaryParserDelegate {
    
    public static let shared = StreamerManager()
    private var sh: SocketHelper?//SocketHelper(url: AppUrl.stream, port: UInt32(AppUrl.port))
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var mapTable = NSMapTable<AnyObject, AnyObject>()
    private var mapOldSymTable = NSMapTable<AnyObject, AnyObject>()
    public var streamerConfig: StreamerConfig?
    public var logConfig: LogConfig = LogConfig()
    public var isStreamingAvailable = true
    private var ssl = false
    public var isBinary = true
    public var reconnectTimeInterval = 2
    
    public override init() {
        super.init()
    }
    
    public func createConnection() {
        if sh == nil {
            if let port = streamerConfig?.socketHostPort, let url = streamerConfig?.socketHostUrl {
                ssl = (streamerConfig?.socketMode == SocketMode.TLS) ? true : false
                sh = SocketHelper(aUrl: url, aPort: UInt32(String(port))!)
            }else{
                logConfig.printLog(msg: ErrorMsgConfig().network_Invalid_response)
            }
        }
        if let socketHelper = sh {
            socketHelper.streamerConfig = streamerConfig
            socketHelper.logConfig = logConfig
            socketHelper.isBinary = isBinary
            socketHelper.reconnectTimeInterval = reconnectTimeInterval
            socketHelper.openStream()
            socketHelper.delegate = self
        }
    }
    
    public func closeConnection() {
        if let socketHelper = sh {
            socketHelper.streamerConfig = streamerConfig
            socketHelper.logConfig = logConfig
            socketHelper.isBinary = isBinary
            socketHelper.reconnectTimeInterval = reconnectTimeInterval
            socketHelper.stopStream()
            NSObject.cancelPreviousPerformRequests(withTarget:socketHelper)
            sh = nil
        }
    }
    
    // MARK: - Subscribtion Methods
    public func subscribe(syms: [String], objSub: StreamerManagerDelegate?, sType: StreamType) {
        for sym in syms {
            subscribes(sym: sym, objSub: objSub, sType: sType)
        }
        startStreamingForType(sType: sType)
    }
    
    private func subscribes(sym: String, objSub: StreamerManagerDelegate?, sType: StreamType) {
        if let obj = objSub {
            let sTypeMap = (mapTable.object(forKey: sType.rawValue as AnyObject)) ?? NSMapTable<AnyObject, AnyObject>()
            mapTable.setObject(sTypeMap, forKey: sType.rawValue as AnyObject)
            
            let subscribArray = (sTypeMap.object(forKey: sym)) ?? NSMutableArray()
            sTypeMap.set(subscribArray, forKey: sym)
            
            if (subscribArray as AnyObject).contains(obj) == false {
                (subscribArray as AnyObject).add(obj)
            }
        }
    }
    
    public func unSubscribe(aSym: String?, objSub: StreamerManagerDelegate?, sType: StreamType) {
        if let obj = objSub {
            if let sTypeMap = getMapTable(sType: sType) {
                let removeSimKeys = NSMutableArray()
                for keySim in sTypeMap.keyEnumerator() {
                    if let sym = aSym {
                        if sym == (keySim as! String) {
                            if let subArray = sTypeMap.object(forKey: (keySim as AnyObject)) as! NSMutableArray? {
                                if subArray.contains(obj) {
                                    subArray.remove(obj)
                                    if subArray.count == 0 {
                                        removeSimKeys.add(keySim)
                                    }
                                }
                            }
                        }
                    }
                }
                for key in removeSimKeys {
                    sTypeMap.removeObject(forKey: (key as AnyObject))
                }
            }
        }
    }
    
    ////    Don't remove the function and need to check
    private func unSubscribe(objSub:StreamerManagerDelegate?, sType:StreamType) {
        if let sTypeMap = getMapTable(sType: sType) {
            let removeSimKeys = NSMutableArray()
            for keySim in sTypeMap.keyEnumerator() {
                if let subArray = sTypeMap.object(forKey: (keySim as AnyObject)) as! NSMutableArray? {
                    if let obj = objSub {
                        if subArray.contains(obj) {
                            subArray.remove(obj)
                            if subArray.count == 0 {
                                removeSimKeys.add(keySim)
                            }
                        }
                    }
                }
            }
            for key in removeSimKeys {
                sTypeMap.removeObject(forKey: (key as AnyObject))
            }
        }
    }
    
    public func unSubscribeAll() {
        mapTable.removeAllObjects()
        mapOldSymTable.removeAllObjects()
    }
    
    // MARK: - Action Methods
    private func startStreamingForType(sType: StreamType) {
        if let arySymbols = getSymbols(sType: sType) {
            request(symbols: arySymbols, sType: sType)
        }
    }
    
    public func stopStreamingForType(sType: StreamType) {
//        request(symbols: nil, sType: sType)
        startStreamingForType(sType: sType)
    }
    
    public func pauseStreamingForType(sType: StreamType) {
        if getSymbols(sType: sType) != nil {
            request(symbols: nil, sType: sType)
            // Should we remove the old backup symbols
            mapOldSymTable.removeObject(forKey: sType.rawValue as AnyObject)
        }
    }
    
    public func resumeStreamingForType(sType: StreamType) {
        startStreamingForType(sType: sType)
    }
    
    // MARK: - Private Methods
    private func getMapTable(sType: StreamType) -> NSMapTable<AnyObject, AnyObject>! {
        for key in mapTable.keyEnumerator() {
            if (key as! String) == sType.rawValue {
                if let sTypeMap = (mapTable.object(forKey: sType.rawValue as AnyObject)) {
                    return (sTypeMap as! NSMapTable<AnyObject, AnyObject>)
                }
            }
        }
        return nil
    }
    
    private func getSymbols(sType: StreamType) -> NSEnumerator! {
        if let sTypeMap = getMapTable(sType: sType) {
            return sTypeMap.keyEnumerator()
        }
        return nil
    }
    
    private func getSubscribers(symbol: String, sType: StreamType) -> NSMutableArray! {
        if let sTypeMap = getMapTable(sType: sType) {
            for sym in sTypeMap.keyEnumerator() {
                if (sym as! String) == symbol {
                    return (sTypeMap.object(forKey: sym as AnyObject) as! NSMutableArray)
                }
            }
        }
        return nil
    }

    private func isSymbolsDublicate(newSymobls: [Any]?, sType: StreamType) -> Bool {
        if let newSyms = newSymobls {
            if let oldSymbols = mapOldSymTable.object(forKey: sType.rawValue as AnyObject) {
                //Check the un-subscribe request
                //If old symbols and new symbols are equal to zero then the previous request is un-subscribe so we return (true), to avoid to send the dublicate un-subscribe
                if oldSymbols.count == 0 && newSyms.count == 0 {
                    return true
                    //If new symbols count is equal to 0 then we should call the un-subscribe request
                } else if newSyms.count == 0 {
                    return false
                } else {
                    //Check the subscribe request
                    //If new symbol is not in old symbols array then return (false) and send subcribe request for new symbols
                    for key in newSyms {
                        if oldSymbols.contains(key) == false {
                            return false
                        }
                    }
                    return true
                }
            } else {
                return false
            }
        } else {
            //If new symbols and Old symbols is equal to nil then we should not call any request
            if mapOldSymTable.object(forKey: sType.rawValue as AnyObject) == nil {
                return true
            }
            //If new symbols are nil, then we should call the unsubscribe request
            return false
        }
    }
    // MARK: - Request Methods
    private func initialStreamRequest(symbols: NSEnumerator?, sType: StreamType) {
        if isStreamingAvailable == true {
            // This is the first request after the connection established, so should not send unsubscrib request and only send subscrib request,
//            so that we have check the syms count > 0
            if let syms = symbols?.allObjects, syms.count > 0 {
                sendStreamRequest(symbols: syms as? [String], sType: sType)
            }
        }
    }
    
    private func request(symbols: NSEnumerator?, sType: StreamType) {
        if isStreamingAvailable == true {
            let syms = symbols?.allObjects
            let isDublicate = isSymbolsDublicate(newSymobls: syms, sType: sType)
            if  isDublicate == false {
                sendStreamRequest(symbols: syms as? [String], sType: sType)
            }
        }
    }
    
    private func sendStreamRequest(symbols: [String]?, sType: StreamType) {
        var reqData = StreamRequestQuote()
        reqData.symbols = [StreamSymbol]()
        
        var request = MSFStreamRequest<StreamRequestQuote>()
        request.request.request_type = StreamRequestType.unsubscribe
        if let newSyms = symbols {
            mapOldSymTable.setObject(symbols as AnyObject, forKey: sType.rawValue as AnyObject)
            for key in newSyms {
                var symbol = StreamSymbol()
                symbol.symbol = key
                reqData.symbols.append(symbol)
            }
        }
        if reqData.symbols.count > 0 {
            request.request.request_type = StreamRequestType.subscribe
        }
        request.request.data = reqData
        request.request.streaming_type = sType.rawValue
        request.request.response_format = (isBinary) ? "json" : nil
        
        do {
            var encodeJSONData =  try encoder.encode(request)
            //Add \n at the end
            encodeJSONData.append(Data("\n".utf8))
            if let socketHelper = sh {
                socketHelper.streamerConfig = streamerConfig
                socketHelper.logConfig = logConfig
                socketHelper.isBinary = isBinary
                socketHelper.reconnectTimeInterval = reconnectTimeInterval
                socketHelper.request(request: encodeJSONData, sType:sType.rawValue)
            }
        } catch {
            logConfig.printLog(msg: error.localizedDescription)
        }
    }
    
    
    
    // MARK: - SocketHelper Delegate Methods
    func responseBinaryReceived(response: [UInt8]) {
        let parser = BinaryParser()
        parser.delegate = self
        parser.setBinaryData(data: response)
    }
    
    func binaryResponseRecived(response: NSDictionary) {
        if let resp = (response)["response"] as? NSDictionary {
            if let sType = resp["streaming_type"] as? StreamType {
                if let data = resp["data"] as? NSDictionary {
                    if(sType == .Quote){
                        let spec = decode(data: data as! [String : Any], type: BinaryStreamerResponse.self)!
                        if let symbol = spec.symbol {
                            if let subscribers = getSubscribers(symbol: symbol, sType: StreamType(rawValue: sType.rawValue)!) {
                                for subscriber in subscribers {
                                    let sub = (subscriber as! StreamerManagerDelegate)
                                    sub.streamingResponseRecived(response: spec)
                                    logConfig.printLog(msg: "\(spec)")
                                }
                            }
                        }
                    }else{
                        let spec = decode(data: data as! [String : Any], type: BinaryQuoteStreamerResponse.self)!
                        if let symbol = spec.symbol {
                            if let subscribers = getSubscribers(symbol: symbol, sType: StreamType(rawValue: sType.rawValue)!) {
                                for subscriber in subscribers {
                                    let sub = (subscriber as! StreamerManagerDelegate)
                                    sub.streamingResponseRecived(response: spec)
                                    logConfig.printLog(msg: "\(spec)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func responseReceived(response: Data) {
        
        do {
            if let json = try JSONSerialization.jsonObject(with: response, options: .mutableContainers) as? [String: Any] {
                if let dicResponse = json["response"] {
                    if let streaming_type = (dicResponse as! [String: Any])["streaming_type"] as? String {
                        if streaming_type == StreamType.Quote.rawValue {
                            do {
                                let res = try decoder.decode(MSFStreamResponse<QuoteStreamerResponse>.self, from: response)
                                if let sType = res.response.streaming_type {
                                    if let symbol = res.response.data?.sym {
                                        if let subscribers = getSubscribers(symbol: symbol, sType: StreamType(rawValue: sType)!) {
                                            for subscriber in subscribers {
                                                let sub = (subscriber as! StreamerManagerDelegate)
                                                sub.streamingResponseRecived(response: res.response.data!)
                                                logConfig.printLog(msg: "\(String(describing: res.response.data))")
                                            }
                                        }
                                    }
                                }
                            } catch {}
                        } else {
                            do {
                                let res = try decoder.decode(MSFStreamResponse<MarketDepthStreamerResponse>.self, from: response)
                                if let sType = res.response.streaming_type {
                                    if let symbol = res.response.data?.sym {
                                        if let subscribers = getSubscribers(symbol: symbol, sType: StreamType(rawValue: sType)!) {
                                            for subscriber in subscribers {
                                                let sub = (subscriber as! StreamerManagerDelegate)
                                                sub.streamingResponseRecived(response: res.response.data!)
                                                logConfig.printLog(msg: "\(String(describing: res.response.data))")
                                            }
                                        }
                                    }
                                }
                            } catch {}
                        }
                    }
                }
            }
        } catch let error as NSError {
            logConfig.printLog(msg: error.localizedDescription)
        }
    }
    
    //Implemented for Delayed Streaming - Called when prospect user to normal user
    func disconnectAndReconnect() {
        closeConnection()
        connectionInetrupted()
    }
    
    func connectionCompleted() {
        callRequestForReconnect()
    }
    
    func connectionInetrupted() {
        // Should we remove the old backup symbols
        mapOldSymTable.removeObject(forKey: StreamType.Quote.rawValue as AnyObject)
        mapOldSymTable.removeObject(forKey: StreamType.Quote2.rawValue as AnyObject)
//        closeConnection()
//        if let url = AppConfig.getStreamerURL(), let port = AppConfig.getStreamerPort() {
//            createConnection(streamingURL: url, streamingPort: port)
//        }
    }
    func callRequestForReconnect() {
        if let arySymbols = getSymbols(sType: .Quote) {
            initialStreamRequest(symbols: arySymbols, sType: .Quote)
        }
        if let arySymbols = getSymbols(sType: .Quote2) {
            initialStreamRequest(symbols: arySymbols, sType: .Quote2)
        }
    }
    
    // MARK: - Testing
    func printObj() {
        for key in mapTable.keyEnumerator() {
            if let sTypeMap = (mapTable.object(forKey: (key as AnyObject))) {
                for keySim in sTypeMap.keyEnumerator() {
                    if let subArray = sTypeMap.object(forKey: (keySim as! String)) as! NSMutableArray? {
                        for _ in subArray {
                        }
                    }
                }
            }
        }
    }
    
    func decode<T: Decodable>(data: [String : Any], type: T.Type) -> T? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data)
            return try JSONDecoder().decode(T.self, from: jsonData)
        } catch {
            return nil
        }
    }
}


