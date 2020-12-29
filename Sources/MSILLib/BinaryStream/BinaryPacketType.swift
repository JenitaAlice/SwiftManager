//
//  BinaryPacketType.swift
//  Binary Streaming
//
//  Created by Janita Alice on 17/12/20.
//

import Foundation

struct PacketType{
    
    public let targetTrackDict: [Int: StreamType] =
        [
            49: .Quote,
            50: .Quote2
        ]
    
    let defaultPktINFO: [String: Any] =
        [
            "PKT_SPEC": [
                49: PacketSpecification().PKT_SPEC49,
                50: PacketSpecification().PKT_SPEC50
            ],
            "BID_ASK_OBJ_LEN": 3
        ]
    
}

struct PacketSpecification{
    
    let PKT_SPEC49: [Int: NSDictionary] =
        [
            65: [
                "type": "string",
                "key": "symbol",
                "len": 20
            ],
            66: [
                "type": "uint8",
                "key": "precision",
                "len": 1
            ],
            67: [
                "type": "float",
                "key": "ltp",
                "len": 8,
                "fmt": "commafmt"
            ],
            68: [
                "type": "float",
                "key": "open",
                "len": 8,
                "fmt": "commafmt"
            ],
            69: [
                "type": "float",
                "key": "high",
                "len": 8,
                "fmt": "commafmt"
            ],
            70: [
                "type": "float",
                "key": "low",
                "len": 8,
                "fmt": "commafmt"
            ],
            71: [
                "type": "float",
                "key": "close",
                "len": 8,
                "fmt": "commafmt"
            ],
            72: [
                "type": "float",
                "key": "chng",
                "len": 8,
                "precision": 2,
                "fmt": "commafmt"
            ],
            73: [
                "type": "float",
                "key": "chngPer",
                "len": 8,
                "fmt": "commafmt"
            ],
            74: [
                "type": "float",
                "key": "atp",
                "len": 8,
                "fmt": "commafmt"
            ],
            75: [
                "type": "float",
                "key": "yHigh",
                "len": 8,
                "fmt": "commafmt"
            ],
            76: [
                "type": "float",
                "key": "yLow",
                "len": 8,
                "fmt": "commafmt"
            ],
            77: [
                "type": "int32",
                "key": "ltq",
                "len": 4,
                "precision": 0,
                "fmt": "commafmt"
            ],
            78: [
                "type": "int32",
                "key": "vol",
                "len": 4,
                "precision": 0,
                "fmt": "commafmt"
            ],
            79: [
                "type": "float",
                "key": "ttv",
                "len": 8,
                "fmt": "commafmt"
            ],
            80: [
                "type": "float",
                "key": "ucl",
                "len": 8,
                "fmt": "commafmt"
            ],
            81: [
                "type": "float",
                "key": "lcl",
                "len": 8,
                "fmt": "commafmt"
            ],
            82: [
                "type": "int32",
                "key": "OI",
                "len": 4,
                "precision": 0,
                "fmt": "commafmt"
            ],
            83: [
                "type": "float",
                "key": "OIChngPer",
                "len": 8,
                "precision": 2,
                "fmt": "commafmt"
            ],
            84: [
                "type": "int32",
                "key": "ltt",
                "len": 4,
                "fmt": "dateFmt"
            ],
        ]
    
    let PKT_SPEC50: [Int: NSDictionary] =
        [
            65: [
                "type": "string",
                "key": "symbol",
                "len": 20
            ],
            66: [
                "type": "uint8",
                "key": "precision",
                "len": 1
            ],
            85: [
                "type": "int32",
                "key": "totBuyQty",
                "len": 4,
                "precision": 0,
                "fmt": "commafmt"
            ],
            86: [
                "type": "int32",
                "key": "totSellQty",
                "len": 4,
                "precision": 0,
                "fmt": "commafmt"
            ],
            //BID
            87: [
                "type": "float",
                "key": "price",
                "len": 8,
                "fmt": "commafmt"
            ],
            88: [
                "type": "int32",
                "key": "qty",
                "len": 4,
                "precision": 0,
                "fmt": "commafmt"
            ],
            89: [
                "type": "int32",
                "key": "no",
                "len": 4,
                "precision": 0,
                "fmt": "commafmt"
            ],
            //ASK
            90: [
                "type": "float",
                "key": "price",
                "len": 8,
                "fmt": "commafmt"
            ],
            91: [
                "type": "int32",
                "key": "qty",
                "len": 4,
                "precision": 0,
                "fmt": "commafmt"
            ],
            92: [
                "type": "int32",
                "key": "no",
                "len": 4,
                "precision": 0,
                "fmt": "commafmt"
            ],
            93: [
                "type": "uint8",
                "key": "nDepth",
                "len": 1
            ]
        ]
    
}

class CommaFormatter {
    
    var value: Double!
    var precision: Int!
    
    init(value: Double, precision: Int) {
        self.value = value
        self.precision = precision
    }
    
    func commaFmt() -> String {
        if(precision == 0){
            return String(Int(value))
        }
        value = value.rounded(toPlaces: precision)
        return formatValue(value: value)
    }
    
    func dateFmt() -> String {
        let timeInterval = TimeInterval(value)
        let myNSDate = Date(timeIntervalSince1970: timeInterval)
        let finaldate = myNSDate.getFormattedDate(format: "dd-MM-yyyy HH:mm:ss")
       return finaldate
    }
    
    func ab2str(index: Int, spec: BinarySpecModel, data: [UInt8]) -> String {
        var finalVal: String = ""
        
        for i in index..<index+spec.len! {
            let string = String(data[i])
            finalVal = finalVal + string
        }
        return finalVal
    }
    
    func formatValue(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        if let formattedString = formatter.string(for: value) {
            return formattedString
        }
        return ""
    }
    
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
