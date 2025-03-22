//
//  ContentView.swift
//  Taipan
//
//  Created by Jeff Milner on 2025-03-21.
//

import SwiftUI
import AVFoundation

// MARK: - Game Screens

struct MainGameView: View {
    @ObservedObject var gameState: GameState
    @State private var currentScreen = "main"
    @State private var message = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 10) {
                HeaderView(gameState: gameState)
                
                if currentScreen == "main" {
                    HStack(alignment: .top, spacing: 10) {
                        VStack(spacing: 10) {
                            WarehouseView(gameState: gameState)
                            CargoView(gameState: gameState)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.55)
                        
                        VStack(spacing: 10) {
                            ShipStatusView(gameState: gameState)
                            
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.35)
                    }
                    
                    FinanceView(gameState: gameState)
                    Spacer()
                    if !message.isEmpty {
                        Text(message)
                            .foregroundColor(.green)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.green, lineWidth: 3)
                            )
                    }
                    CommandButtonsView(gameState: gameState, currentScreen: $currentScreen)

                } else if currentScreen == "buy" {
                    BuyView(gameState: gameState, currentScreen: $currentScreen, showMessage: showCustomMessage)
                } else if currentScreen == "sell" {
                    SellView(gameState: gameState, currentScreen: $currentScreen, showMessage: showCustomMessage)
                } else if currentScreen == "bank" {
                    BankView(gameState: gameState, currentScreen: $currentScreen, showMessage: showCustomMessage)
                } else if currentScreen == "transfer" {
                    TransferView(gameState: gameState, currentScreen: $currentScreen, showMessage: showCustomMessage)
                } else if currentScreen == "travel" {
                    TravelView(gameState: gameState, currentScreen: $currentScreen, showMessage: showCustomMessage, showAlert: showCustomAlert)
                } else if currentScreen == "wu" {
                    WuView(gameState: gameState, currentScreen: $currentScreen, showMessage: showCustomMessage)
                } else if currentScreen == "battle" {
                    BattleView(gameState: gameState, currentScreen: $currentScreen, showMessage: showCustomMessage)
                } else if currentScreen == "retire" {
                    RetireView(gameState: gameState, currentScreen: $currentScreen, showMessage: showCustomMessage)
                } else if currentScreen == "start" {
                    NewGameView(gameState: gameState, currentScreen: $currentScreen)
                }
            }
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            if gameState.firmName.isEmpty {
                currentScreen = "start"
            }
        }
    }
    
    func showCustomMessage(_ msg: String) {
        message = msg
        print("Showing custom message: \(msg)")
        
        // Clear the message after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
            if message == msg {
                message = ""
            }
        }
    }
    
    func showCustomAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}

//#Preview {
//    ContentView()
//}
