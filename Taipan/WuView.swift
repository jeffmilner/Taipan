//
//  WuView.swift
//  Taipan
//
//  Created by Jeff Milner on 2025-03-21.
//

import SwiftUI

struct WuView: View {
    @ObservedObject var gameState: GameState
    @Binding var currentScreen: String
    @State private var debtPayment = ""
    @State private var loanAmount = ""
    let showMessage: (String) -> Void
    
    var body: some View {
        VStack {
            Text("Elder Brother Wu's House")
                .font(.title)
                .foregroundColor(.green)
                .padding()
            
            if gameState.cash == 0 && gameState.bank == 0 && gameState.currentLoad == 0 && gameState.guns == 0 {
                // Player is broke, offer loan
                let loanOffer = gameState.fnR(1500) + 500
                let payback = gameState.fnR(2000) * gameState.bankLoanCount + 1500
                
                Text("Elder Brother Wu is aware of your plight, Taipan.")
                    .foregroundColor(.yellow)
                    .padding()
                
                Text("He is willing to loan you \(loanOffer) if you will pay back \(payback).")
                    .foregroundColor(.yellow)
                    .padding()
                
                HStack {
                    Button("Accept Loan") {
                        gameState.cash += loanOffer
                        gameState.debt += payback
                        gameState.bankLoanCount += 1
                        currentScreen = "main"
                        showMessage("Good joss, Taipan!")
                    }
                    .buttonStyle(TaipanButtonStyle())
                    
                    Button("Decline") {
                        currentScreen = "main"
                        showMessage("Very well, Taipan, the game is over!")
                    }
                    .buttonStyle(TaipanButtonStyle())
                }
                .padding()
            } else {
                if gameState.debt > 0 {
                    HStack {
                        Text("Your Debt: \(gameState.debt)")
                            .foregroundColor(.yellow)
                    }
                    .padding(.horizontal)
                    
                    TextField("Amount to Pay", text: $debtPayment)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    HStack {
                        Button("Pay Debt") {
                            payDebt()
                        }
                        .buttonStyle(TaipanButtonStyle())
                        
                        Button("Maximum") {
                            let maxPay = min(gameState.cash, gameState.debt)
                            debtPayment = "\(maxPay)"
                        }
                        .buttonStyle(TaipanButtonStyle())
                    }
                    .padding()
                }
                
                Divider()
                    .background(Color.gray)
                    .padding()
                
                HStack {
                    Text("Your Cash: \(gameState.cash)")
                        .foregroundColor(.yellow)
                }
                .padding(.horizontal)
                
                TextField("Amount to Borrow", text: $loanAmount)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                HStack {
                    Button("Request Loan") {
                        requestLoan()
                    }
                    .buttonStyle(TaipanButtonStyle())
                    
                    Button("Done") {
                        currentScreen = "main"
                    }
                    .buttonStyle(TaipanButtonStyle())
                }
                .padding()
            }
        }
        .background(Color.black.opacity(0.7))
        .cornerRadius(16)
    }
    
    func payDebt() {
        guard var amount = Int(debtPayment), amount > 0 else {
            showMessage("Please enter a valid amount")
            return
        }
        
        if amount > gameState.cash {
            showMessage("You only have \(gameState.cash) in cash.")
            return
        }
        
        if amount > gameState.debt {
            amount = gameState.debt
        }
        
        gameState.cash -= amount
        gameState.debt -= amount
        debtPayment = ""
        showMessage("Paid \(amount) toward your debt")
    }
    
    func requestLoan() {
        guard let amount = Int(loanAmount), amount > 0 else {
            showMessage("Please enter a valid amount")
            return
        }
        
        // Simple formula for loan approval - can't borrow more than twice your cash
        if amount > gameState.cash * 2 {
            showMessage("Elder Brother Wu won't loan you so much!")
            return
        }
        
        gameState.cash += amount
        gameState.debt += amount
        loanAmount = ""
        showMessage("Received loan of \(amount)")
    }
}

//#Preview {
//    WuView()
//}
