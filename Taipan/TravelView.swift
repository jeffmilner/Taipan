//
//  TravelView.swift
//  Taipan
//
//  Created by Jeff Milner on 2025-03-21.
//

import SwiftUI

struct TravelView: View {
    @ObservedObject var gameState: GameState
    @Binding var currentScreen: String
    @State private var selectedPort = 1
    let showMessage: (String) -> Void
    let showAlert: (String, String) -> Void
    
    var body: some View {
        VStack {
            Text("Set Sail")
                .font(.title)
                .foregroundColor(.green)
                .padding()
            
            if gameState.currentLoad > gameState.shipCapacity {
                Text("WARNING: Your ship is overloaded!")
                    .foregroundColor(.red)
                    .padding()
            }
            
            Text("Current Location: \(gameState.ports[gameState.currentPort].name)")
                .foregroundColor(.yellow)
                .padding()
            
            Text("Destination:")
                .foregroundColor(.white)
                .padding(.top)
            VStack {
                ForEach(Array(1..<gameState.ports.count), id: \.self) { i in
                    Button(gameState.ports[i].name){
                        selectedPort = i
                        travel()
                    }
                    .buttonStyle(TaipanButtonStyle())
                }
            }
//            Picker("Select Port", selection: $selectedPort) {
//                ForEach(Array(1..<gameState.ports.count), id: \.self) { i in
//                    if i != gameState.currentPort {
//                        Text(gameState.ports[i].name).tag(i)
//                    }
//                }
//            }
 //           .pickerStyle(WheelPickerStyle())
            
//            HStack {
//                Button("Set Sail") {
//                    if gameState.currentLoad > gameState.shipCapacity {
//                        showAlert("Overloaded Ship", "Your ship is overloaded and might not survive the journey!")
//                    } else {
//                        travel()
//                    }
//                }
//                .buttonStyle(TaipanButtonStyle())
//                
//                Button("Cancel") {
//                    currentScreen = "main"
//                }
//                .buttonStyle(TaipanButtonStyle())
//            }
            .padding()
        }
        .background(Color.black.opacity(0.7))
        .cornerRadius(16)
    }
    
    func travel() {
        if selectedPort == gameState.currentPort {
            showMessage("You're already there!")
            return
        }
        
        gameState.destinationPort = selectedPort
        
        // Check for random events (pirates, storms, battles)
        let eventRoll = gameState.fnR(100)
        
        if eventRoll < 20 {  // Battle
            let ships = gameState.fnR(gameState.shipCapacity / 10 + gameState.guns) + 1
            showMessage("\(ships) hostile ship(s) approaching!")
            // Start battle sequence
            simulateBattle(ships: ships)
        } else if eventRoll < 35 && gameState.liYuenStatus == 0 {  // Li Yuen's pirates
            showMessage("Li Yuen's pirates!")
            let ships = gameState.fnR(gameState.shipCapacity / 5 + gameState.guns) + 5
            simulateBattle(ships: ships, liYuen: true)
        } else if eventRoll < 45 {  // Storm
            handleStorm()
        } else {
            // Safe journey
            completeTravelToPort()
        }
    }
    
    func simulateBattle(ships: Int, liYuen: Bool = false) {
        // For simplicity, we'll just simulate the battle result rather than implementing the full battle system
        let battleRoll = gameState.fnR(100)
        let shipPower = gameState.guns * 15
        let enemyPower = ships * 10
        
        if battleRoll + shipPower > enemyPower {
            // Victory
            let booty = gameState.fnR(gameState.timeTraded / 4 * 1000 * Int(Double(ships).squareRoot())) + gameState.fnR(1000) + 250
            gameState.cash += booty
            showMessage("Victory! Captured \(booty) in booty!")
            completeTravelToPort()
        } else {
            // Damage to ship
            gameState.shipDamage += gameState.fnR(ships * 5) + ships / 2
            
            // Chance of losing a gun
            if gameState.guns > 0 && gameState.fnR(100) < 20 {
                gameState.guns -= 1
                gameState.currentLoad -= 10
                showMessage("The enemy hit one of your guns!")
            }
            
            // Check if ship is destroyed
            if gameState.getShipStatusPercentage() <= 0 {
                showAlert("Ship Destroyed", "Your ship has been destroyed in battle!")
                currentScreen = "start"  // Restart game
                return
            }
            
            // Try to escape
            let escapeRoll = gameState.fnR(100)
            if escapeRoll < 30 {
                showMessage("We've managed to escape!")
                completeTravelToPort()
            } else {
                // Continue battle next round - but for simplicity we'll just complete travel
                showMessage("The battle was fierce, but we survived!")
                completeTravelToPort()
            }
        }
    }
    
    func handleStorm() {
        showMessage("Storm!")
        
        // Chance of sinking based on ship damage
        let stormRoll = gameState.fnR(100)
        let sinkChance = Int(Double(gameState.shipDamage) / Double(gameState.shipCapacity) * 100)
        
        if stormRoll < sinkChance {
            showAlert("Ship Lost", "Your ship has sunk in the storm!")
            currentScreen = "start"  // Restart game
            return
        }
        
        // Possible additional damage
        gameState.shipDamage += gameState.fnR(10) + 5
        
        // Check if blown off course
        if gameState.fnR(100) < 30 {
            var newPort = gameState.fnR(7) + 1
            while newPort == gameState.currentPort || newPort == gameState.destinationPort {
                newPort = gameState.fnR(7) + 1
            }
            
            gameState.destinationPort = newPort
            showMessage("Blown off course to \(gameState.ports[newPort].name)!")
        }
        
        completeTravelToPort()
    }
    
    func completeTravelToPort() {
        gameState.currentPort = gameState.destinationPort
        gameState.updateCommodityPrices()
        gameState.advanceTime()
        currentScreen = "main"
    }
}

//#Preview {
//    TravelView()
//}
