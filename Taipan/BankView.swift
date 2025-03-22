//
//  BankView.swift
//  Taipan
//
//  Created by Jeff Milner on 2025-03-21.
//

import SwiftUI

struct BankView: View {
    @ObservedObject var gameState: GameState
    @Binding var currentScreen: String
    @State private var depositAmount = ""
    @State private var withdrawAmount = ""
    @State private var showingDeposit = true
    let showMessage: (String) -> Void
    
    var body: some View {
        VStack {
            Text("Bank of Hong Kong")
                .font(.title)
                .foregroundColor(.green)
                .padding()
            
            Picker("Transaction", selection: $showingDeposit) {
                Text("Deposit").tag(true)
                Text("Withdraw").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if showingDeposit {
                HStack {
                    Text("Cash: \(gameState.cash)")
                        .foregroundColor(.yellow)
                }
                .padding(.horizontal)
                
                TextField("Amount to Deposit", text: $depositAmount)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                HStack {
                    Button("Deposit") {
                        deposit()
                    }
                    .buttonStyle(TaipanButtonStyle())
                    
                    Button("Maximum") {
                        depositAmount = "\(gameState.cash)"
                    }
                    .buttonStyle(TaipanButtonStyle())
                }
                .padding()
            } else {
                HStack {
                    Text("Bank Balance: \(gameState.bank)")
                        .foregroundColor(.yellow)
                }
                .padding(.horizontal)
                
                TextField("Amount to Withdraw", text: $withdrawAmount)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                HStack {
                    Button("Withdraw") {
                        withdraw()
                    }
                    .buttonStyle(TaipanButtonStyle())
                    
                    Button("Maximum") {
                        withdrawAmount = "\(gameState.bank)"
                    }
                    .buttonStyle(TaipanButtonStyle())
                }
                .padding()
            }
            
            Button("Done") {
                currentScreen = "main"
            }
            .buttonStyle(TaipanButtonStyle())
            .padding()
        }
        .background(Color.black.opacity(0.7))
        .cornerRadius(16)
    }
    
    func deposit() {
        guard let amount = Int(depositAmount), amount > 0 else {
            showMessage("Please enter a valid amount")
            return
        }
        
        if amount > gameState.cash {
            showMessage("You only have \(gameState.cash) in cash.")
            return
        }
        
        gameState.cash -= amount
        gameState.bank += amount
        depositAmount = ""
        showMessage("Deposited \(amount) to bank")
    }
    
    func withdraw() {
        guard let amount = Int(withdrawAmount), amount > 0 else {
            showMessage("Please enter a valid amount")
            return
        }
        
        if amount > gameState.bank {
            showMessage("You only have \(gameState.bank) in the bank.")
            return
        }
        
        gameState.bank -= amount
        gameState.cash += amount
        withdrawAmount = ""
        showMessage("Withdrew \(amount) from bank")
    }
}

//#Preview {
//    BankView()
//}
