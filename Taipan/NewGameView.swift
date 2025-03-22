//
//  NewGameView.swift
//  Taipan
//
//  Created by Jeff Milner on 2025-03-21.
//

import SwiftUI

struct NewGameView: View {
    @ObservedObject var gameState: GameState
    @Binding var currentScreen: String
    @State private var firmName = ""
    @State private var startWithGuns = false
    
    var body: some View {
        VStack {
            Text("Taipan")
                .font(.largeTitle)
                .foregroundColor(.green)
                .padding()
            
            Text("What will you name your firm?")
                .foregroundColor(.yellow)
                .padding()
            
            TextField("Firm Name", text: $firmName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.words)
            
            Text("Do you want to start...")
                .foregroundColor(.green)
                .padding(.top)
            
            VStack(alignment: .leading) {
                Toggle(isOn: $startWithGuns) {
                    if startWithGuns {
                        Text("With five guns and no cash (but no debt!)")
                    } else {
                        Text("With cash (and a debt of 5000)")
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .foregroundColor(.white)
                .padding()
            }
            
            Button("Begin Adventure") {
                if firmName.trimmingCharacters(in: .whitespaces).isEmpty {
                    firmName = "Trading Co."
                }
                
                gameState.firmName = firmName
                gameState.setupNewGame(withGuns: startWithGuns)
                currentScreen = "main"
            }
            .buttonStyle(TaipanButtonStyle())
            .padding()
        }
        .frame(maxWidth: 400)
        .padding()
        .background(Color.black.opacity(0.8))
        .cornerRadius(16)
    }
}

//#Preview {
//    NewGameView()
//}
