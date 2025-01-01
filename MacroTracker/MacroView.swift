//
//  MacroView.swift
//  MacroTracker
//
//  Created by Dean Elbery on 2024-12-31.
//

import SwiftUI

struct MacroView: View {
    @State var carbs: Int = 91
    @State var fats: Int = 33
    @State var protein: Int = 67
    
    var body: some View {
        NavigationStack {
            VStack{
                Text("Today's Macros")
                    .font(.title)
                
                MacroItemView(carbs: $carbs, fats: $fats, protein: $protein)
                    .padding()
                
                
                VStack(alignment: .leading) {
                    Text("Previous Meals")
                        .font(.title)
                        .scrollIndicators(.hidden)
                        .toolbar {
                            ToolbarItem{
                                Button{
                                    print("Add")
                                } label: {
                                    Image(systemName: "plus")
                                        .foregroundStyle(.black, .white)
                                }
                            }
                        }
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(0..<10) { _ in
                            MacroItemView(carbs: .constant(Int.random(in: 10..<200)), fats: .constant(Int.random(in: 10..<200)), protein: .constant(Int.random(in: 10..<200)))
                                .padding()
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            
        }
        .task {
            do {
                try await OpenAIService.shared.sendPromptToChatGPT(message: "Slice of cheese pizza")
            } catch {
                print(error.localizedDescription)
                }
            }
        }
    }
        

#Preview {
    MacroView()
}
