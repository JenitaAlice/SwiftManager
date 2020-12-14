//
//  SocketHandler.swift
//  Streaming SDK
//
//  Created by Janita Alice on 08/12/20.
//

#if !os(macOS)

import UIKit

protocol SocketHelperDelegate: class {
    func responseReceived(response: Data)
    func connectionCompleted()
    func connectionInetrupted()
    func callRequestForReconnect()
}

class SocketHelper: NSObject, StreamDelegate {
    var url: String?
    var port: UInt32?
    var iStream: InputStream?
    var oStream: OutputStream?
    var commonStr: String?
    lazy var lastRequest = Dictionary<String, Data> ()
    var ssl = false
    weak var delegate: SocketHelperDelegate?
    
    init(aUrl: String, aPort: UInt32) {
        super.init()
        url = aUrl
        port = aPort
        self.commonStr = String()
    }
    
    func request(request: Data, sType:String) {
    if oStream?.hasSpaceAvailable == true {
            request.withUnsafeBytes { (buffer: UnsafePointer<UInt8>) in
                var len: Int
                len = (oStream?.write(buffer, maxLength: request.count))!
                if len<1 {
                    streamError()
                } else {
                    //print("Stream request : \(String.init(data: request, encoding: String.Encoding.utf8) ?? "")")
                }
            }
        }else {
            lastRequest[sType] = request
        }
    }
    func openStream() {
        if let aUrl = url, iStream == nil && oStream == nil {
            var readStream: Unmanaged<CFReadStream>?
            var writeStream: Unmanaged<CFWriteStream>?
            
            CFStreamCreatePairWithSocketToHost(
                kCFAllocatorDefault,
                aUrl as CFString,
                port!,
                &readStream,
                &writeStream)
            
            iStream = readStream!.takeRetainedValue()
            oStream = writeStream!.takeRetainedValue()
            
            if ssl == true {
                let dict = [
                    kCFStreamSSLValidatesCertificateChain: kCFBooleanFalse,     // allow self-signed certificate
                    kCFStreamSSLLevel: kCFStreamSSLValidatesCertificateChain    // don't understand, why there isn't a constant for version 1.2
                    ] as CFDictionary
                
                let sslSetRead = CFReadStreamSetProperty(iStream, CFStreamPropertyKey(kCFStreamPropertySSLSettings), dict)
                let sslSetWrite = CFWriteStreamSetProperty(oStream, CFStreamPropertyKey(kCFStreamPropertySSLSettings), dict)
                
                if sslSetRead == false || sslSetWrite == false {
                    //print("SSL Configuration Failed")
                }
            }
            commonStr = ""
            open(iStream)
            open(oStream)
            print("Open Stream")
        }
    }
    func open(_ stream: Stream?) {
        if let aStream = stream {
            aStream.delegate = self
            aStream.schedule(in: RunLoop.main, forMode: .common)
            aStream.open()
        }
    }
    func stopStream() {
        print("Stop Stream")
        close(iStream)
        close(oStream)
        iStream = nil
        oStream = nil
    }
    func close(_ stream: Stream?) {
        if nil != stream {
            stream?.close()
            stream?.remove(from: RunLoop.main, forMode: .common)
        }
    }
    func resetStream() {
        stopStream()
        openStream()
    }
    func responseReceived(response: Data?) {
        if let data = response {
            if let del = delegate {
                del.responseReceived(response: data)
            }
        }
    }
    func streamError() {
        stopStream()
        NSObject.cancelPreviousPerformRequests(withTarget:self)
        perform(#selector(callReconnect), with: nil, afterDelay: 2)
    }
    @objc func callReconnect() {
        if let del = delegate {
            del.connectionInetrupted()
        }
    }
    func bufferTokenize(output: Data?) {
        if let outData = output {
            if let jsonStr = String(data: outData, encoding: String.Encoding.utf8) {
                commonStr = commonStr?.appending(jsonStr)
                if let array = commonStr?.components(separatedBy: "\n") {
                    commonStr = array.last
                    if let delegate = delegate {
                        var i = 0
                        while i < array.count - 1 {
                            delegate.responseReceived(response: Data(array[i].utf8))
                            i += 1
                        }
                    }
                }
            }
        }
    }
    func streamReady() {
        let sTypes = lastRequest.keys
        for sType in sTypes {
            if let req = lastRequest[sType] {
                request(request: req, sType: sType)
            }
        }
        lastRequest.removeAll()
    }
    // MARK: StreamDelegate
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
//        print("Stream : \(aStream.debugDescription) Event : \(eventCode.rawValue)")
        switch eventCode {
        case .endEncountered, .errorOccurred:
            streamError()
            break
        case .hasBytesAvailable:
            if let iStream = iStream {
                if aStream == iStream {
                    //read data
                    let bufferSize = 1024
                    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
                    var len: Int
                    while iStream.hasBytesAvailable {
                        len = iStream.read(buffer, maxLength: bufferSize)
                        if len > 0 {
                            let output = Data.init(bytes: buffer, count: len)
                            bufferTokenize(output: output)
                        }else {
                            break
                        }
                    }
                    buffer.deallocate()
                }
            }
            break
        case .hasSpaceAvailable:
            if aStream == oStream! {
                streamReady()
            }
            break
        case .openCompleted:
            if aStream == oStream! {
                if let del = delegate {
                    del.connectionCompleted()
                }
            }
            break
        default:
            break
        }
    }
}

#endif
