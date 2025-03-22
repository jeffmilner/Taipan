//
//  CommandButtonsView.swift
//  Taipan
//
//  Created by Jeff Milner on 2025-03-21.
//

import SwiftUI

struct CommandButtonsView: View {
    @ObservedObject var gameState: GameState
    @Binding var currentScreen: String
    
    var body: some View {
        VStack {
            HStack {
                Button("Buy") {
                    currentScreen = "buy"
                }
                .buttonStyle(TaipanButtonStyle())
                
                Button("Sell") {
                    currentScreen = "sell"
                }
                .buttonStyle(TaipanButtonStyle())
                
                if gameState.currentPort == 1 {
                    Button("Move Cargo") {
                        currentScreen = "transfer"
                    }
                    .buttonStyle(TaipanButtonStyle())
                }
            }
            
            HStack {
                if gameState.currentPort == 1 {
                    Button("Bank") {
                        currentScreen = "bank"
                    }
                    .buttonStyle(TaipanButtonStyle())
                }
                Button("Set Sail") {
                    currentScreen = "travel"
                }
                .buttonStyle(TaipanButtonStyle())
                
                if gameState.currentPort == 1 {
                    Button("Visit Wu") {
                        currentScreen = "wu"
                    }
                    .buttonStyle(TaipanButtonStyle())
                }
            }
            
            if gameState.currentPort == 1 && gameState.netWorth() >= 1_000_000 {
                Button("Retire") {
                    currentScreen = "retire"
                }
                .buttonStyle(TaipanButtonStyle())
            }
        }
    }
}

struct TaipanButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(minWidth: 80)
            .background(Color.green.opacity(configuration.isPressed ? 0.8 : 1))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

//#Preview {
//    CommandButtonsView()
//}
