//
//  File.swift
//  
//
//  Created by Janita Alice on 31/12/20.
//

import Foundation
import CommonCrypto

struct AES256 {

    private var key: Data
    private var iv: Data

    public init(key: Data, iv: Data) throws {

        self.key = key
        self.iv = iv
    }

    enum Error: Swift.Error {
        case keyGeneration(status: Int)
        case cryptoFailed(status: CCCryptorStatus)
        case badKeyLength
        case badInputVectorLength
    }

    func encrypt(_ digest: Data) throws -> Data {
        return try crypt(input: digest, operation: CCOperation(kCCEncrypt))
    }

    func decrypt(_ encrypted: Data) throws -> Data {
        return try crypt(input: encrypted, operation: CCOperation(kCCDecrypt))
    }

    private func crypt(input: Data, operation: CCOperation) throws -> Data {
        var outLength = Int(0)
        var outBytes = [UInt8](repeating: 0, count: input.count + kCCBlockSizeAES128)
        var status: CCCryptorStatus = CCCryptorStatus(kCCSuccess)
        input.withUnsafeBytes { (encryptedBytes: UnsafePointer<UInt8>!) -> Void in
            iv.withUnsafeBytes { (ivBytes: UnsafePointer<UInt8>!) in
                key.withUnsafeBytes { (keyBytes: UnsafePointer<UInt8>!) -> Void in
                    status = CCCrypt(operation,
                                     CCAlgorithm(kCCAlgorithmAES),            // algorithm
                        CCOptions(kCCOptionPKCS7Padding),           // options
                        keyBytes,                                   // key
                        key.count,                                  // keylength
                        ivBytes,                                    // iv
                        encryptedBytes,                             // dataIn
                        input.count,                                // dataInLength
                        &outBytes,                                  // dataOut
                        outBytes.count,                             // dataOutAvailable
                        &outLength)                                 // dataOutMoved
                }
            }
        }
        guard status == kCCSuccess else {
            throw Error.cryptoFailed(status: status)
        }
        return Data(bytes: UnsafePointer<UInt8>(outBytes), count: outLength)
    }

    static func getKeyBytes(password: String) throws -> Data {

        let keyBytes = Data(count: 16)
        let parameterKeyBytes = password.data(using: .utf8)
        let startIndex = 0
        let length = min(keyBytes.count, parameterKeyBytes!.count)
        let b = Array(parameterKeyBytes![startIndex ..< startIndex+length]) //array copy
        return Data(bytes: UnsafePointer<UInt8>(b), count: length)
    }
}

