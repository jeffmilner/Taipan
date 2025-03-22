//
//  ShipStatusView.swift
//  Taipan
//
//  Created by Jeff Milner on 2025-03-21.
//

import SwiftUI

struct ShipStatusView: View {
    @ObservedObject var gameState: GameState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack {
                Text("Date:")
                Text("\(gameState.month)/\(gameState.year)")
                    .foregroundColor(.yellow)
            }
            
            VStack {
                Text("Location:")
                Text(gameState.ports[gameState.currentPort].name)
                    .foregroundColor(.yellow)
            }
            
            VStack {
                Text("Debt:")
                Text("\(gameState.formatLargeNumber(gameState.debt))")
                    .foregroundColor(.yellow)
            }
            
            VStack {
                Text("Ship Status:")
                Text("\(gameState.getShipStatus()): \(gameState.getShipStatusPercentage())%")
                    .foregroundColor(getStatusColor(gameState.getShipStatusPercentage()))
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
    
    func getStatusColor(_ percentage: Int) -> Color {
        if percentage < 20 { return .red }
        if percentage < 40 { return .orange }
        if percentage < 60 { return .yellow }
        if percentage < 80 { return .green }
        return .blue
    }
}

//#Preview {
//    ShipStatusView()
//}
