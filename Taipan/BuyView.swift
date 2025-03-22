//
//  BuyView.swift
//  Taipan
//
//  Created by Jeff Milner on 2025-03-21.
//

import SwiftUI

struct BuyView: View {
    @ObservedObject var gameState: GameState
    @Binding var currentScreen: String
    @State private var selectedCommodity = 0
    @State private var amount = ""
    let showMessage: (String) -> Void
    
    var body: some View {
        VStack {
            Text("Buy Goods")
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
                Text("You can afford: \(gameState.cash / gameState.commodityPrices[selectedCommodity])")
                    .foregroundColor(.yellow)
            }
            .padding(.horizontal)
            
            TextField("Amount", text: $amount)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button("Buy") {
                    buyGoods()
                }
                .buttonStyle(TaipanButtonStyle())
                
                Button("Maximum") {
                    amount = "\(gameState.cash / gameState.commodityPrices[selectedCommodity])"
                    print("amount is now \(amount). Maximum capacity is \(gameState.shipCapacity)")
                    if amount > "\(gameState.shipCapacity)" {
                        amount = "\(gameState.shipCapacity)"
                        print("amount is greater than maximum capacity. Setting amount to maximum capacity: \(amount)")
                    }
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
    
    func buyGoods() {
        print("buyGoods() called")
        
        guard let amountValue = Int(amount), amountValue > 0 else {
            showMessage("Please enter a valid amount")
            return
        }
        
        let cost = amountValue * gameState.commodityPrices[selectedCommodity]
        print("Calculated cost: \(cost), cash: \(gameState.cash), amountValue: \(amountValue)")
        print("Ship Capacity: \(gameState.shipCapacity), Current Load: \(gameState.currentLoad)")
            
        if cost > gameState.cash {
            showMessage("You don't have enough cash!")
            return
        }
        
        if amountValue > gameState.shipCapacity - gameState.currentLoad {
            showMessage("Your ship would be overburdened!")
            return
        }
        
        // Update state
        gameState.currentLoad += amountValue
        print("updating currentLoad: \(gameState.currentLoad)")
        gameState.cash -= cost
        print("updating cash: \(gameState.cash)")
        
        //this code was brought in because pushing the buy button didn't do anything.
        
        gameState.shipInventory[selectedCommodity] += amountValue
        
        currentScreen = "main"
        showMessage("Purchased \(amountValue) \(gameState.commodities[selectedCommodity].name)")
    }
}

//#Preview {
//    BuyView()
//}
