//
//  FinanceView.swift
//  Taipan
//
//  Created by Jeff Milner on 2025-03-21.
//

import SwiftUI

struct FinanceView: View {
    @ObservedObject var gameState: GameState
    
    var body: some View {
        HStack {
            Text("Cash: \(gameState.formatLargeNumber(gameState.cash))")
                .foregroundColor(.yellow)
            Spacer()
            Text("Bank: \(gameState.formatLargeNumber(gameState.bank))")
                .foregroundColor(.green)
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(8)
    }
}

//#Preview {
//    FinanceView()
//}
