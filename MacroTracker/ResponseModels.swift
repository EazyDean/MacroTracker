//
//  ResponseModels.swift
//  MacroTracker
//
//  Created by Dean Elbery on 2025-01-01.
//

import Foundation

struct GPTResponse: Decodable {
    let choices: [GPTCompletion]
}

struct GPTCompletion: Decodable {
    let message: GPTResponseMessage
    
}

struct GPTResponseMessage: Decodable {
    let functionCall: GPTFunctionCall
    
    enum CodingKeys: String, CodingKey {
        case functionCall = "function_call"
    }
}

struct GPTFunctionCall: Decodable {
    let name: String
    let arguments: String
}

struct MacroResponse: Decodable {
    let food: String
    let fats: Int
    let proteins: Int
    let carbs: Int
    
}
