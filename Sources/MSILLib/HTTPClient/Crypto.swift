//
//  File.swift
//  
//
//  Created by Janita Alice on 31/12/20.
//

import Foundation
extension Data {
    var hexString: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

class Crypto {

    init() {

    }
    static func encryptText(key: String, textStr: String) -> Data {
//        var encrypted: Data?
        do {
            let digest = textStr.data(using: .utf8)! //getbytes
            let iv = try AES256.getKeyBytes(password: key) //getkeybytes
            let key = try AES256.getKeyBytes(password: key) //getkeybytes
            let aes = try AES256(key: key, iv: iv)
            let encrypted = try aes.encrypt(digest)
            return encrypted
        } catch {
            //print("Failed")
            //print(error)
            //return "error"
            let encrypted = error.localizedDescription.data(using: .utf8)
            return encrypted!
        }
    }

    static func decryptText(key: String, textData: Data) -> Data {
        var decrypted: Data?
        do {
            let digest = textData
            let iv = try AES256.getKeyBytes(password: key)
            let key = try AES256.getKeyBytes(password: key)
            let aes = try AES256(key: key, iv: iv)
            let decrypted = try aes.decrypt(digest)
            return decrypted
        } catch {
            //print("Failed")
            //print(error)
            //return "error"
            decrypted = error.localizedDescription.data(using: .utf8)
            return decrypted!
        }
    }

}

