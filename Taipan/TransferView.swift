//
//  TransferView.swift
//  Taipan
//
//  Created by Jeff Milner on 2025-03-21.
//

import SwiftUI

struct TransferView: View {
    @ObservedObject var gameState: GameState
    @Binding var currentScreen: String
    @State private var selectedCommodity = 0
    @State private var direction = 0  // 0: Ship to Warehouse, 1: Warehouse to Ship
    @State private var amount = ""
    let showMessage: (String) -> Void
    
    var body: some View {
        VStack {
            Text("Transfer Cargo")
                .font(.title)
                .foregroundColor(.green)
                .padding()
            
            Picker("Direction", selection: $direction) {
                Text("Ship to Warehouse").tag(0)
                Text("Warehouse to Ship").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Picker("Commodity", selection: $selectedCommodity) {
                ForEach(0..<4) { i in
                    Text(gameState.commodities[i].name).tag(i)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if direction == 0 {
                HStack {
                    Text("On Ship: \(gameState.shipInventory[selectedCommodity])")
                    Spacer()
                    Text("Warehouse Space: \(gameState.warehouseCapacity - gameState.warehouseUsed)")
                }
                .foregroundColor(.yellow)
                .padding(.horizontal)
            } else {
                HStack {
                    Text("In Warehouse: \(gameState.warehouseStorage[selectedCommodity])")
                    Spacer()
                    Text("Ship Space: \(gameState.shipCapacity - gameState.currentLoad)")
                }
                .foregroundColor(.yellow)
                .padding(.horizontal)
            }
            
            TextField("Amount", text: $amount)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button("Transfer") {
                    transferCargo()
                }
                .buttonStyle(TaipanButtonStyle())
                
                Button("Maximum") {
                    if direction == 0 {
                        let maxTransfer = min(
                            gameState.shipInventory[selectedCommodity],
                            gameState.warehouseCapacity - gameState.warehouseUsed
                        )
                        amount = "\(maxTransfer)"
                    } else {
                        let maxTransfer = min(
                            gameState.warehouseStorage[selectedCommodity],
                            gameState.shipCapacity - gameState.currentLoad
                        )
                        amount = "\(maxTransfer)"
                    }
                }
                .buttonStyle(TaipanButtonStyle())
                
                Button("Done") {
                    currentScreen = "main"
                }
                .buttonStyle(TaipanButtonStyle())
            }
            .padding()
        }
        .background(Color.black.opacity(0.7))
        .cornerRadius(16)
    }
    
    func transferCargo() {
        guard let amountValue = Int(amount), amountValue > 0 else {
            showMessage("Please enter a valid amount")
            return
        }
        
        if direction == 0 {  // Ship to Warehouse
            if amountValue > gameState.shipInventory[selectedCommodity] {
                showMessage("You don't have that much on your ship!")
                return
            }
            
            if amountValue > gameState.warehouseCapacity - gameState.warehouseUsed {
                showMessage("Your warehouse doesn't have enough space!")
                return
            }
            
            gameState.shipInventory[selectedCommodity] -= amountValue
            gameState.warehouseStorage[selectedCommodity] += amountValue
            gameState.currentLoad -= amountValue
            gameState.warehouseUsed += amountValue
            
            showMessage("Transferred \(amountValue) \(gameState.commodities[selectedCommodity].name) to warehouse")
        } else {  // Warehouse to Ship
            if amountValue > gameState.warehouseStorage[selectedCommodity] {
                showMessage("You don't have that much in your warehouse!")
                return
            }
            
            if amountValue > gameState.shipCapacity - gameState.currentLoad {
                showMessage("Your ship doesn't have enough space!")
                return
            }
            
            gameState.warehouseStorage[selectedCommodity] -= amountValue
            gameState.shipInventory[selectedCommodity] += amountValue
            gameState.warehouseUsed -= amountValue
            gameState.currentLoad += amountValue
            
            showMessage("Transferred \(amountValue) \(gameState.commodities[selectedCommodity].name) to ship")
        }
        
        amount = ""
    }
}

//#Preview {
//    TransferView()
//}
