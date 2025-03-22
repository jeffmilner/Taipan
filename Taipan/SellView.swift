//
//  SellView.swift
//  Taipan
//
//  Created by Jeff Milner on 2025-03-21.
//

import SwiftUI

struct SellView: View {
    @ObservedObject var gameState: GameState
    @Binding var currentScreen: String
    @State private var selectedCommodity = 0
    @State private var amount = ""
    let showMessage: (String) -> Void
    
    var body: some View {
        VStack {
            Text("Sell Goods")
                .font(.title)
                .foregroundColor(.green)
                .padding()
            
            ForEach(0..<4) { i in
                HStack {
                    Text(gameState.commodities[i].name)
                    Spacer()
                    Text("\(gameState.commodityPrices[i])")
                        .foregroundColor(.yellow)
                }
                .padding(.horizontal)
            }
            
            Picker("Select Commodity", selection: $selectedCommodity) {
                ForEach(0..<4) { i in
                    Text(gameState.commodities[i].name).tag(i)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            HStack {
                Text("You have: \(gameState.shipInventory[selectedCommodity])")
                    .foregroundColor(.yellow)
            }
            .padding(.horizontal)
            
            TextField("Amount", text: $amount)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button("Sell") {
                    sellGoods()
                }
                .buttonStyle(TaipanButtonStyle())
                
                Button("Maximum") {
                    amount = "\(gameState.shipInventory[selectedCommodity])"
                }
                .buttonStyle(TaipanButtonStyle())
                
                Button("Cancel") {
                    currentScreen = "main"
                }
                .buttonStyle(TaipanButtonStyle())
            }
            .padding()
        }
        .background(Color.black.opacity(0.7))
        .cornerRadius(16)
    }
    
    func sellGoods() {
        guard let amountValue = Int(amount), amountValue > 0 else {
            showMessage("Please enter a valid amount")
            return
        }
        
        if amountValue > gameState.shipInventory[selectedCommodity] {
            showMessage("You don't have that much!")
            return
        }
        
        let profit = amountValue * gameState.commodityPrices[selectedCommodity]
        
        gameState.currentLoad -= amountValue
        gameState.cash += profit
        gameState.shipInventory[selectedCommodity] -= amountValue
        
        currentScreen = "main"
        showMessage("Sold \(amountValue) \(gameState.commodities[selectedCommodity].name) for \(profit)")
    }
}

//#Preview {
//    SellView()
//}
