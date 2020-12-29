//
//  LogConfig.swift
//  Binary Streaming
//
//  Created by Janita Alice on 28/12/20.
//

import Foundation

public class LogConfig {
    
    var showLog: Bool  = false
    
    func printLog(msg: String) {
        if(showLog){
          print(msg)
        }
    }
    
}
