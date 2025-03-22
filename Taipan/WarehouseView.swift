//
//  WarehouseView.swift
//  Taipan
//
//  Created by Jeff Milner on 2025-03-21.
//

import SwiftUI

struct WarehouseView: View {
    @ObservedObject var gameState: GameState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Hong Kong Warehouse")
                .font(.headline)
                .padding(.bottom, 4)
            
            ForEach(0..<4) { i in
                HStack {
                    Text(gameState.commodities[i].name)
                    Spacer()
                    Text("\(gameState.warehouseStorage[i])")
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
//    WarehouseView()
//}
