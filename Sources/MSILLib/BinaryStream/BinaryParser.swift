//
//  BinaryParser.swift
//  Binary Streaming
//
//  Created by Janita Alice on 16/12/20.
//

import Foundation
import SWCompression

protocol BinaryParserDelegate: class {
    func binaryResponseRecived(response: NSDictionary)
}
    
class BinaryParser: NSObject {
    
    var binaryData:[UInt8] = []
    
    private let encoder = JSONEncoder()
    
    var delegate: BinaryParserDelegate?
    
    func setBinaryData(data: [UInt8]) {
        binaryData = binaryData + data
        process()
    }
    
    func resetBinary() {
        binaryData.removeAll()
    }
    
    func process() {
        
        LogConfig().printLog(msg: "\(binaryData)")
        
        if(binaryData.count > 5){
            
            let bufferData = Data(binaryData[0..<4])
            let bufferValue: UInt32 = bufferData.withUnsafeBytes { $0.load(as: UInt32.self) }
            let length = bufferValue.littleEndian
            
            let compressionAlgo = Int(binaryData[4])
            
            if(binaryData.count >= length){
                
                let singleBinaryPacketData =  Array(binaryData[5..<binaryData.count])
                //print("Single Binary Packet Data", singleBinaryPacketData)
                
                if(compressionAlgo == 10){
                    decompressZLib(data: singleBinaryPacketData)
                }else{
                    processDecomData(data: singleBinaryPacketData)
                }
                
                binaryData = Array(binaryData[Int(length)..<binaryData.count])
                
                process()
                
            }
            
        }
    }
    
    func processDecomData(data: [UInt8]) {
        
        if(data.count <= 0){
            print("Decompressed Length is wrong exiting the loop")
            return
        }
        
        let length = data.count
        let lastProcLen = decodePKT(data: Array(data[0..<Int(length)]))
        
        if(lastProcLen <= 0){
            print("Packet Length is wrong exiting the loop $lastProcLen")
            return
        }
            
    }
    
    func decodePKT(data: [UInt8]) -> Int {
        
        let bufferData = Data(data[0..<2])
        let bufferValue: UInt16 = bufferData.withUnsafeBytes { $0.load(as: UInt16.self) }
        let pktLen = bufferValue.littleEndian
        
        let pktType = Int(data[2])
        
        let pktSpec: NSDictionary = PacketType().defaultPktINFO["PKT_SPEC"] as! NSDictionary
        let specMatrix = pktSpec[Int(pktType)]
        
        if (specMatrix == nil) {
            print("Unknown PktType \(pktType)")
            return Int(pktLen)
        }
        
        let packetType: StreamType = PacketType().targetTrackDict[Int(pktType)] ?? .Quote
        
        var jData: NSDictionary = [:]
        
        if(packetType == .Quote){
            jData = decodeL1PKT(specMatrix: specMatrix as! NSDictionary, pktLen: Int(pktLen), data: data) as NSDictionary
        }else if(packetType == .Quote2){
            jData = decodeL2PKT(specMatrix: specMatrix as! NSDictionary, pktLen: Int(pktLen), data: data) as NSDictionary
        }
        
        if(jData == [:]){
            return Int(pktLen)
        }
        
        var response: [String: AnyObject] = [:]
        response["data"] = jData as AnyObject
        response["streaming_type"] = packetType as AnyObject
        let r: NSDictionary = ["response": response]
        delegate?.binaryResponseRecived(response: r)
        
        return Int(pktLen)
    }
    
    func decodeL1PKT(specMatrix: NSDictionary, pktLen: Int, data: [UInt8]) -> [String: Any] {
        
        var rawData: [String: Any] = [:]
        var precision: Int = 2
        var index = 3
        
        while(index >= 3 && index < pktLen){
            
            let pktKey = Int(data[index])
            
            index = index + 1
            
            let jsonSpec = specMatrix[pktKey]
            
            if(jsonSpec == nil){
                print("Unknown Pkt spec breaking \(pktKey)")
                return [:]
            }
            
            let spec = decode(data: jsonSpec as! [String : Any], type: BinarySpecModel.self)!
            
            if(spec.type == "string"){
                
                let bufferData = Data(data[index...(index+(spec.len!-1))])
                if let bufferString = String(bytes: bufferData, encoding: .utf8) {
                    rawData[(spec.key)!] = [jsonSpec, bufferString]
                } else {
                    print("not a valid UTF-8 sequence")
                }

            }else if(spec.type == "float"){
                
                let bufferArray = Array(data[index...(index+(spec.len!-1))])
                let value = Double(bufferArray)
                rawData[(spec.key)!] = [jsonSpec, value]

            }else if(spec.type == "int32"){
                
                let bufferData = Data(data[index...(index+(spec.len!-1))])
                let bufferValue: UInt32 = bufferData.withUnsafeBytes { $0.load(as: UInt32.self) }
                let value = bufferValue.littleEndian
                rawData[(spec.key)!] = [jsonSpec, value]

            }else if(spec.type == "uint8"){
                
                let bufferValue = Int(data[index])
                if(spec.key == "precision"){
                    precision = bufferValue
                }else{
                    rawData[(spec.key)!] = [jsonSpec, bufferValue]
                }
                
            }
            
            index += spec.len!;

        }
        

        var jData: [String: Any] = [:]

        for (key, _) in rawData {
            let spec = rawData[key] as? NSArray
            let specKey = decode(data: spec![0] as! [String : Any], type: BinarySpecModel.self)
            let finalValue: String
            if let specValue = spec?[1] as? Int {
                if(specKey?.fmt == "dateFmt"){
                    finalValue = CommaFormatter(value: Double(specValue), precision: precision).dateFmt()
                }else{
                    if let decimal = specKey?.precision {
                        finalValue = CommaFormatter(value: Double(specValue), precision: decimal).commaFmt()
                    }else{
                        finalValue = CommaFormatter(value: Double(specValue), precision: precision).commaFmt()
                    }
                }
                jData[key] = finalValue
            }else if let specValue = spec?[1] as? NSNumber {
                if let decimal = specKey?.precision {
                    finalValue = CommaFormatter(value: specValue.doubleValue, precision: decimal).commaFmt()
                }else{
                    finalValue = CommaFormatter(value: specValue.doubleValue, precision: precision).commaFmt()
                }
                jData[key] = finalValue
            }else if let specValue = spec?[1] as? String {
                jData[key] = specValue.replacingOccurrences(of: "\0", with: "")
            }
        }
        
        return jData
        
    }
    
    func decodeL2PKT(specMatrix: NSDictionary, pktLen: Int, data: [UInt8]) -> [String: Any] {
        
        var precision: Int = 2
        var noLevel: Int = 0
        var index = 3
        
        var bids: [[String: Any]] = []
        var asks: [[String: Any]] = []
        var list: [[String: Any]]?
        
        var isBids: Bool = true
        
        var lObj: [String: Any] = [:]
        var rawData: [String: Any] = [:]
        
        while(index >= 3 && index < pktLen){
            
            let pktKey = Int(data[index])
            
            index = index + 1
            
            let jsonSpec = specMatrix[pktKey]
            
            if(jsonSpec == nil){
                print("Unknown Pkt spec breaking \(pktKey)")
                return [:]
            }
            
            let spec = decode(data: jsonSpec as! [String : Any], type: BinarySpecModel.self)!
            
            if(spec.type == "string"){
                
                let bufferData = Data(data[index...(index+(spec.len!-1))])
                if let bufferString = String(bytes: bufferData, encoding: .utf8) {
                    rawData[(spec.key)!] = [jsonSpec, bufferString]
                } else {
                    print("not a valid UTF-8 sequence")
                }
                
            }else if(spec.type == "float"){
                
                let bufferArray = Array(data[index...(index+(spec.len!-1))])
                let value = Double(bufferArray)
                
                if(list == nil){
                    rawData[(spec.key)!] = [jsonSpec, CommaFormatter(value: Double(value!), precision: spec.precision!).commaFmt()]
                }else{
                    if(spec.fmt != nil){
                        if(spec.precision != nil){
                            lObj[(spec.key)!] = CommaFormatter(value: value!, precision: spec.precision!).commaFmt()
                        }else{
                            lObj[(spec.key)!] = CommaFormatter(value: value!, precision: precision).commaFmt()
                        }
                    }else{
                        lObj[(spec.key)!] = String(value!)
                    }
                }
                
            }else if(spec.type == "int32"){
                
                let bufferData = Data(data[index...(index+(spec.len!-1))])
                let bufferValue: UInt32 = bufferData.withUnsafeBytes { $0.load(as: UInt32.self) }
                let value = bufferValue.littleEndian
                
                if(list == nil){
                    rawData[(spec.key)!] = [jsonSpec, CommaFormatter(value: Double(value), precision: spec.precision!).commaFmt()]
                }else{
                    if(spec.fmt != nil){
                        if(spec.precision != nil){
                            lObj[(spec.key)!] = CommaFormatter(value: Double(value), precision: spec.precision!).commaFmt()
                        }else{
                            lObj[(spec.key)!] = CommaFormatter(value: Double(value), precision: precision).commaFmt()
                        }
                    }else{
                        lObj[(spec.key)!] = String(value)
                    }
                        
                }
                
            }else if(spec.type == "uint8"){
                
                let bufferValue = Int(data[index])
                if(spec.key == "nDepth"){
                    noLevel = bufferValue
                    list = bids
                }else if(spec.key == "precision"){
                    precision = bufferValue
                }else{
                    rawData[(spec.key)!] = [jsonSpec, bufferValue]
                }
                
            }
            
            index += spec.len!
            
            if(list != nil){
                if(lObj.keys.count == PacketType().defaultPktINFO["BID_ASK_OBJ_LEN"] as! Int){
                    // Once 'price', 'qty' and 'no-orders', these 3 items are received in this iteration
                    // pushing the object to the current list, and creating a new object for the next set.
                    list?.append(lObj)
                    lObj = [:]
                }
                
                // Once the list size reaches the desired length, means all bids are received.
                // then assigning new state 'ask' to the list, which will be container
                // for next set of packets.
                if(noLevel == list?.count){
                    if(isBids){
                        bids = list!
                        list = asks
                        isBids = false
                    }else{
                        asks = list!
                        isBids = true
                    }
                }
                
            }
            
        }
        
        var jData: [String: Any] = [:]
        
        for (key, _) in rawData {
            let spec = rawData[key] as? NSArray
            let specKey = decode(data: spec![0] as! [String : Any], type: BinarySpecModel.self)
            let finalValue: String
            if let specValue = spec?[1] as? Int {
                if let decimal = specKey?.precision {
                    finalValue = CommaFormatter(value: Double(specValue), precision: decimal).commaFmt()
                }else{
                    finalValue = CommaFormatter(value: Double(specValue), precision: precision).commaFmt()
                }
            }else if let specValue = spec?[1] as? NSNumber {
                if let decimal = specKey?.precision {
                    finalValue = CommaFormatter(value: specValue.doubleValue, precision: decimal).commaFmt()
                }else{
                    finalValue = CommaFormatter(value: specValue.doubleValue, precision: precision).commaFmt()
                }
                jData[key] = finalValue
            }else if let specValue = spec?[1] as? String {
                jData[key] = specValue.replacingOccurrences(of: "\0", with: "")
            }
        }
        
        jData["bid"] = bids
        jData["ask"] = asks

        return jData
    }
    
    func decompressZLib(data: [UInt8]) {
        
        let dataBuffer = Data(bytes: data, count: data.count)
        
        do {

            let decompressedData = try ZlibArchive.unarchive(archive: dataBuffer)
            //print("Decompressed Data", [UInt8](decompressedData))
            processDecomData(data: [UInt8](decompressedData))
            
            
        } catch let error as ZlibError {
           print(error)
        } catch let error {
            print(error)
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
    
    func ab2str(index: Int, spec: BinarySpecModel, data: [UInt8]) -> String {
        var finalVal: String = ""
        
        for i in index..<index+spec.len! {
            let string = String(data[i])
            finalVal = finalVal + string
        }
        return finalVal
    }
    
}


extension FloatingPoint {

    init?(_ bytes: [UInt8]) {

        guard bytes.count == MemoryLayout<Self>.size else { return nil }

        self = bytes.withUnsafeBytes {

            return $0.load(fromByteOffset: 0, as: Self.self)
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
