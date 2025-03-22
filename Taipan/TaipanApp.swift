//
//  TaipanApp.swift
//  Taipan
//
//  Created by Jeff Milner on 2025-03-21.
//

import SwiftUI

@main
struct TaipanApp: App {
    @StateObject private var gameState = GameState()
    
    var body: some Scene {
        WindowGroup {
            MainGameView(gameState: gameState)
                .preferredColorScheme(.dark)
                .background(
                    Image(systemName: "water.waves")
                        .resizable(resizingMode: .tile)
                        .foregroundColor(.blue.opacity(0.1))
                        .ignoresSafeArea()
                )
        }
    }
}
