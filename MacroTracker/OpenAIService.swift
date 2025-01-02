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
        
        let result = try JSONDecoder().decode(GPTResponse.self, from: data)
        let args = result.choices[0].message.functionCall.arguments
        let argData = Data(args.utf8)  // Convert the string to Data
        let macro = try JSONDecoder().decode(MacroResponse.self, from: argData)
        print(macro)
    }
}
