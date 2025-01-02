//
//  RequestModels.swift
//  MacroTracker
//
//  Created by Dean Elbery on 2025-01-01.
//

import Foundation

struct GPTChatPayLoad : Encodable {
    let model : String
    let messages : [GPTMessage]
    let functions : [GPTFunction]
}

struct GPTMessage : Encodable {
    let role : String
    let content : String
}

struct GPTFunction : Encodable {
    let name : String
    let description : String
    let parameters : GPTFunctionParameters
}

struct GPTFunctionParameters : Encodable {
    let type : String
    let properties : [String:GPTFunctionProperty]?
    let required : [String]?
}

struct GPTFunctionProperty : Encodable {
    let type: String
    let description : String
}
