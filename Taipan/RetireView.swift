//
//  RetireView.swift
//  Taipan
//
//  Created by Jeff Milner on 2025-03-21.
//

import SwiftUI

struct RetireView: View {
    @ObservedObject var gameState: GameState
    @Binding var currentScreen: String
    let showMessage: (String) -> Void
    
    var body: some View {
        VStack {
            Text("You're a MILLIONAIRE!")
                .font(.largeTitle)
                .foregroundColor(.yellow)
                .padding()
            
            Text("Final Status:")
                .font(.title)
                .foregroundColor(.green)
                .padding()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Net Worth: \(gameState.formatLargeNumber(gameState.netWorth()))")
                    .foregroundColor(.white)
                
                Text("Ship size: \(gameState.shipCapacity) units with \(gameState.guns) guns")
                    .foregroundColor(.white)
                
                let years = gameState.timeTraded / 12
                let months = gameState.timeTraded % 12
                Text("You traded for \(years) year\(years != 1 ? "s" : "") and \(months) month\(months != 1 ? "s" : "")")
                    .foregroundColor(.white)
                
                Text("Your score is \(gameState.netWorth())")
                    .foregroundColor(.yellow)
                    .fontWeight(.bold)
                    .padding(.top)
            }
            .padding()
            
            Text("Your Rating:")
                .font(.title2)
                .foregroundColor(.green)
                .padding()
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Ma Tsu")
                        .foregroundColor(gameState.netWorth() >= 50000 ? .yellow : .white)
                        .fontWeight(gameState.netWorth() >= 50000 ? .bold : .regular)
                    Spacer()
                    Text("50,000 and over")
                        .foregroundColor(.white)
                }
                
                HStack {
                    Text("Master Taipan")
                        .foregroundColor(gameState.netWorth() >= 8000 && gameState.netWorth() < 50000 ? .yellow : .white)
                        .fontWeight(gameState.netWorth() >= 8000 && gameState.netWorth() < 50000 ? .bold : .regular)
                    Spacer()
                    Text("8,000 to 49,999")
                        .foregroundColor(.white)
                }
                
                HStack {
                    Text("Taipan")
                        .foregroundColor(gameState.netWorth() >= 1000 && gameState.netWorth() < 8000 ? .yellow : .white)
                        .fontWeight(gameState.netWorth() >= 1000 && gameState.netWorth() < 8000 ? .bold : .regular)
                    Spacer()
                    Text("1,000 to 7,999")
                        .foregroundColor(.white)
                }
                
                HStack {
                    Text("Compradore")
                        .foregroundColor(gameState.netWorth() >= 500 && gameState.netWorth() < 1000 ? .yellow : .white)
                        .fontWeight(gameState.netWorth() >= 500 && gameState.netWorth() < 1000 ? .bold : .regular)
                    Spacer()
                    Text("500 to 999")
                        .foregroundColor(.white)
                }
                
                HStack {
                    Text("Galley Hand")
                        .foregroundColor(gameState.netWorth() < 500 ? .yellow : .white)
                        .fontWeight(gameState.netWorth() < 500 ? .bold : .regular)
                    Spacer()
                    Text("less than 500")
                        .foregroundColor(.white)
                }
            }
            .padding()
            
            if gameState.netWorth() < 99 {
                Text("Have you considered a land based job?")
                    .foregroundColor(.orange)
                    .padding()
            }
            
            Button("Play Again") {
                currentScreen = "start"
            }
            .buttonStyle(TaipanButtonStyle())
            .padding()
        }
        .background(Color.black.opacity(0.7))
        .cornerRadius(16)
    }
}

//#Preview {
//    RetireView()
//}
