//
//  MacroItemView.swift
//  MacroTracker
//
//  Created by Dean Elbery on 2025-01-01.
//

import SwiftUI

struct MacroItemView: View {
    @Binding var carbs: Int
    @Binding var fats: Int
    @Binding var protein: Int
    var body: some View {
        HStack {
            Spacer()
            
            VStack{
                Image("carbs")
                    .resizable()
                    .scaledToFit()
                    .frame(width:60)
                Text("Carbs")
                
                Text("\(carbs)g")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.1))
            )
            Spacer()
            
            VStack{
                Image("fats")
                    .resizable()
                    .scaledToFit()
                    .frame(width:60)
                Text("Fats")
                
                Text("\(fats)g")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.1))
            )
            Spacer()
            
            VStack{
                Image("protein")
                    .resizable()
                    .scaledToFit()
                    .frame(width:60)
                Text("Proteins")
                
                Text("\(protein)g")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.1))
            )
            Spacer()
        }
    }
}

#Preview {
    MacroItemView(
        carbs: .constant(18), fats: .constant(42), protein: .constant(120)
    )
}
