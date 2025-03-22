//
//  CargoView.swift
//  Taipan
//
//  Created by Jeff Milner on 2025-03-21.
//

import SwiftUI

struct CargoView: View {
    @ObservedObject var gameState: GameState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Cargo Hold")
                .font(.headline)
                .padding(.bottom, 4)
            
            HStack {
                Text("In use:")
                Spacer()
                Text("\(gameState.currentLoad)")
            }
            
            HStack {
                Text("Vacant:")
                Spacer()
                Text("\(gameState.shipCapacity - gameState.currentLoad)")
            }
            
            Divider()
            
            HStack {
                Text("Guns:")
                Spacer()
                Text("\(gameState.guns)")
            }
            
            ForEach(0..<4) { i in
                HStack {
                    Text(gameState.commodities[i].name)
                    Spacer()
                    Text("\(gameState.shipInventory[i])")
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.green, lineWidth: 3)
        )
    }
}

//#Preview {
//    CargoView()
//}
