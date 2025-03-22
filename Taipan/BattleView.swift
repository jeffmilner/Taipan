//
//  BattleView.swift
//  Taipan
//
//  Created by Jeff Milner on 2025-03-21.
//

import SwiftUI

struct BattleView: View {
    @ObservedObject var gameState: GameState
    @Binding var currentScreen: String
    let showMessage: (String) -> Void
    @State private var enemyShips = 0
    @State private var battleStatus = ""
    
    var body: some View {
        VStack {
            Text("Battle!")
                .font(.title)
                .foregroundColor(.red)
                .padding()
            
            Text("\(enemyShips) ships attacking!")
                .foregroundColor(.yellow)
                .font(.headline)
                .padding()
            
            Text("Your orders are to:")
                .foregroundColor(.white)
                .padding()
            
            Text(battleStatus)
                .foregroundColor(.orange)
                .italic()
                .padding()
            
            HStack {
                Button("Run") {
                    attemptRun()
                }
                .buttonStyle(TaipanButtonStyle())
                
                Button("Fight") {
                    fight()
                }
                .buttonStyle(TaipanButtonStyle())
                .disabled(gameState.guns == 0)
                
                Button("Throw Cargo") {
                    currentScreen = "throw"
                }
                .buttonStyle(TaipanButtonStyle())
            }
            .padding()
        }
        .background(Color.black.opacity(0.7))
        .cornerRadius(16)
        .onAppear {
            enemyShips = 5  // Example number of ships
            battleStatus = "What shall we do, Taipan?"
        }
    }
    
    func attemptRun() {
        let escapeRoll = gameState.fnR(100)
        
        if escapeRoll > 50 {  // 50% chance of escape
            battleStatus = "We got away from them, Taipan!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                gameState.currentPort = gameState.destinationPort
                gameState.advanceTime()
                currentScreen = "main"
            }
        } else {
            battleStatus = "Can't lose them!"
            enemyFires()
        }
    }
    
    func fight() {
        if gameState.guns == 0 {
            battleStatus = "We have no guns, Taipan!"
            return
        }
        
        battleStatus = "We're firing on them, Taipan!"
        
        // Each gun has a chance to sink an enemy ship
        var sunkShips = 0
        for _ in 0..<gameState.guns {
            if enemyShips > 0 && gameState.fnR(100) < 40 {  // 40% chance per gun
                sunkShips += 1
                enemyShips -= 1
            }
        }
        
        if sunkShips > 0 {
            battleStatus = "Sunk \(sunkShips) of the buggers, Taipan!"
        } else {
            battleStatus = "Hit them, but didn't sink any, Taipan!"
        }
        
        if enemyShips == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                battleStatus = "We got them all, Taipan!"
                
                // Capture some booty
                let booty = gameState.fnR(1000) + 500
                gameState.cash += booty
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    gameState.currentPort = gameState.destinationPort
                    gameState.advanceTime()
                    currentScreen = "main"
                }
            }
        } else {
            enemyFires()
        }
    }
    
    func enemyFires() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            battleStatus = "They're firing on us, Taipan!"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                battleStatus = "We've been hit, Taipan!"
                
                // Damage calculation
                let damage = gameState.fnR(enemyShips * 5) + enemyShips
                gameState.shipDamage += damage
                
                // Chance to lose a gun
                if gameState.guns > 0 && gameState.fnR(100) < 20 {
                    gameState.guns -= 1
                    gameState.currentLoad -= 10
                    battleStatus = "The buggers hit a gun, Taipan!"
                }
                
                // Check if ship is destroyed
                if gameState.getShipStatusPercentage() <= 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        battleStatus = "The buggers got us, Taipan! It's all over!"
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            currentScreen = "start"  // Game over
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    BattleView()
//}
