//
//  ErrorMsgConfig.swift
//  Binary Streaming
//
//  Created by Janita Alice on 28/12/20.
//

import Foundation

class ErrorMsgConfig {
    
    let showErrorCode: Bool  = true
    let network_Error_unable_to_connect: String  = "Not able to connect to Server. Please check your internet"
    let network_Invalid_response: String = "Invalid response from server. Please try again"
    let network_unable_to_read_resp: String  = "Server is busy. Please try again"
    let connection_issue: String = "Network connection issue, Can you please Retry"
    let internal_Error_Occured_Message: String = "Internal Error. Please try again"
    let no_url_request: String = "Unable to create the URLRequest object"
    let parse_failure: String = "Data parsing failure"
    let request_failure: String = "Data request failure"
    
}
