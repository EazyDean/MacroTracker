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
        guard let url = URL(string: "https://api.openai.com/v1/completion") else {
            throw URLError(.badURL)
        }
        
        var urlREquest = URLRequest(url: url)
        
        // Method
        urlREquest.httpMethod = httpMethod.rawValue
        
        // Header
        urlREquest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlREquest.addValue("Bearer \(Secrets.apiKey)", forHTTPHeaderField: "Authorization")
        
        // Body
        let userMessage = GPTMessage(role: "user", content: message)
        let systemMessage = GPTMessage(role: "system", content: "You are a macronutrient expert")
        
        return URLRequest(url: url)
    }
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
