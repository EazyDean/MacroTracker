//
//  OpenAIService.swift
//  MacroTracker
//
//  Created by Dean Elbery on 2025-01-01.
//

import Foundation

enum HTTPMethod : String{
    case post = "POST"
    case get = "GET"
}
class OpenAIService {
    
    static let shared = OpenAIService()
    
    private init () { }
    
    private func generateURLRequest(httpMethod : HTTPMethod, message: String) throws -> URLRequest {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        
        // Method
        urlRequest.httpMethod = httpMethod.rawValue
        
        // Header
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(Secrets.apiKey)", forHTTPHeaderField: "Authorization")
        
        // Body
        let userMessage = GPTMessage(role: "user", content: message)
        let systemMessage = GPTMessage(role: "system", content: "You are a macronutrient expert")
        
        let food = GPTFunctionProperty(type: "string", description: "The food item e.g. hamburger")
        let fats = GPTFunctionProperty(type: "integer", description: "The amount of fats in grams of the given food item")
        let carbs = GPTFunctionProperty(type: "integer", description: "The amount of carbohydrates in grams of the given food item")
        let proteins = GPTFunctionProperty(type: "integer", description: "The amount of proteins in grams of the given food item")
        let params: [String:GPTFunctionProperty] = [
            "food" : food,
            "fats" : fats,
            "carbs" : carbs,
            "proteins" : proteins
        ]
        
        let functionParameters = GPTFunctionParameters(type: "object", properties: params, required: ["food", "fats", "carbs", "proteins"])
        let function = GPTFunction(name: "get_macronutrients", description: "Get the macronutrient for a given food", parameters: functionParameters)
        let payload = GPTChatPayLoad(model: "gpt-4o-mini", messages: [systemMessage, userMessage ], functions: [function])
        
        let jsonData = try JSONEncoder().encode(payload)
        
        urlRequest.httpBody = jsonData
        return urlRequest
    }
    func sendPromptToChatGPT(message: String) async throws {
        let urlRequest = try generateURLRequest(httpMethod: .post, message: message)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        print(String(data: data, encoding: .utf8)!)
    }
}

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
